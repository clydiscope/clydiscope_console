class FabricationOrchestrator
  def create(prompt)
    response = FabricationInterpreter.new.interpret(prompt)

    data = JSON.parse(response.body)
    command_text = data["choices"][0]["message"]["content"]
    command = JSON.parse(command_text)

    validator = FabricationCommandValidator.new

    unless validator.valid?(command)
    raise "Invalid fabrication command"
    end

    FabricationService.new.create_cube(command["size_mm"])

  end
end