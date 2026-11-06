require "test_helper"

class FabricationCommandValidatorTest < ActiveSupport::TestCase
  test "accepts a valid 20 mm cube command" do
    command = {
      "operation" => "create_cube",
      "size_mm" => 20,
    }

    validator = FabricationCommandValidator.new

    assert validator.valid?(command)
  end

  test "rejects a negative cube size" do
    command = {
      "operation" => "create_cube",
      "size_mm" => -20,
    }

    validator = FabricationCommandValidator.new

    assert_not validator.valid?(command)
  end

  test "rejects unauthorized operations" do
    command = {
      "operation" => "delete_everything",
      "size_mm" => 20,
    }

    validator = FabricationCommandValidator.new

    assert_not validator.valid?(command)
  end

  test "accepts maximum cube size" do
    command = {
      "operation" => "create_cube",
      "size_mm" => 200,
    }

    validator = FabricationCommandValidator.new

    assert validator.valid?(command)
  end

  test "rejects cube sizes above maximum" do
    command = {
      "operation" => "create_cube",
      "size_mm" => 200.001,
    }

    validator = FabricationCommandValidator.new

    assert_not validator.valid?(command)
  end

  test "rejects zero cube size" do
    command = {
      "operation" => "create_cube",
      "size_mm" => 0,
    }

    validator = FabricationCommandValidator.new

    assert_not validator.valid?(command)
  end

  test "rejects non-numeric cube sizes" do
    command = {
      "operation" => "create_cube",
      "size_mm" => "twenty",
    }

    validator = FabricationCommandValidator.new

    assert_not validator.valid?(command)
  end

  test "rejects missing cube size" do
    command = {
      "operation" => "create_cube",
    }

    validator = FabricationCommandValidator.new

    assert_not validator.valid?(command)
  end

  test "accepts a small positive cube size" do
    command = {
      "operation" => "create_cube",
      "size_mm" => 0.001,
    }

    validator = FabricationCommandValidator.new

    assert validator.valid?(command)
  end
end
