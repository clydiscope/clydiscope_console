require "test_helper"

class FabricationOrchestratorTest < ActiveSupport::TestCase
  test "creates a cube from a valid AI command" do
    command = {
      "operation" => "create_cube",
      "size_mm" => 20,
    }

    ai_response = {
      "choices" => [
        {
          "message" => {
            "content" => command.to_json,
          },
        },
      ],
    }

    assert_equal 20, command["size_mm"]
  end

  test "simulates the AI interpreter" do
    fake_response = Struct.new(:body).new("simulated response")

    fake_interpreter = Object.new

    fake_interpreter.define_singleton_method(:interpret) do |_prompt|
      fake_response
    end

    response = fake_interpreter.interpret("Make me a 20 mm cube")

    assert_equal "simulated response", response.body
  end

  test "orchestrator sends correct cube size" do
    command = {
      "operation" => "create_cube",
      "size_mm" => 20,
    }

    ai_response = {
      "choices" => [
        {
          "message" => {
            "content" => command.to_json,
          },
        },
      ],
    }

    fake_response = Struct.new(:body).new(ai_response.to_json)

    fake_interpreter = Object.new
    fake_interpreter.define_singleton_method(:interpret) do |_prompt|
      fake_response
    end

    fake_service = Object.new
    fake_service.define_singleton_method(:create_cube) do |size|
      size
    end

    original_interpreter_new = FabricationInterpreter.method(:new)
    original_service_new = FabricationService.method(:new)

    begin
      FabricationInterpreter.define_singleton_method(:new) { fake_interpreter }
      FabricationService.define_singleton_method(:new) { fake_service }

      result = FabricationOrchestrator.new.create("Make me a 20 mm cube")

      assert_equal 20, result
    ensure
      FabricationInterpreter.define_singleton_method(:new, original_interpreter_new)
      FabricationService.define_singleton_method(:new, original_service_new)
    end
  end

  test "rejects invalid cube before fabrication" do
    command = {
      "operation" => "create_cube",
      "size_mm" => -20,
    }

    ai_response = {
      "choices" => [
        {
          "message" => {
            "content" => command.to_json,
          },
        },
      ],
    }

    fake_response = Struct.new(:body).new(ai_response.to_json)

    fake_interpreter = Object.new
    fake_interpreter.define_singleton_method(:interpret) do |_prompt|
      fake_response
    end

    fake_service = Object.new
    fake_service.define_singleton_method(:create_cube) do |_size|
      raise "SECURITY FAILURE: fabrication service was called"
    end

    original_interpreter_new = FabricationInterpreter.method(:new)
    original_service_new = FabricationService.method(:new)

    begin
      FabricationInterpreter.define_singleton_method(:new) { fake_interpreter }
      FabricationService.define_singleton_method(:new) { fake_service }

      error = assert_raises(InvalidFabricationCommandError) do
        FabricationOrchestrator.new.create("Make me a -20 mm cube")
      end

      assert_equal "Invalid fabrication command", error.message
    ensure
      FabricationInterpreter.define_singleton_method(:new, original_interpreter_new)
      FabricationService.define_singleton_method(:new, original_service_new)
    end
  end

  test "rejects malformed AI command JSON" do
    ai_response = {
      "choices" => [
        {
          "message" => {
            "content" => '{"operation":"create_cube","size_mm":20',
          },
        },
      ],
    }

    fake_response = Struct.new(:body).new(ai_response.to_json)

    fake_interpreter = Object.new
    fake_interpreter.define_singleton_method(:interpret) do |_prompt|
      fake_response
    end

    original_interpreter_new = FabricationInterpreter.method(:new)

    begin
      FabricationInterpreter.define_singleton_method(:new) { fake_interpreter }

      assert_raises(JSON::ParserError) do
        FabricationOrchestrator.new.create("Make me a 20 mm cube")
      end
    ensure
      FabricationInterpreter.define_singleton_method(:new, original_interpreter_new)
    end
  end
end
