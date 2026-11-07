class InvalidAIResponseError < StandardError
end

class InvalidFabricationCommandError < StandardError
end

class FabricationOrchestrator
  def create(prompt)
    response = FabricationInterpreter.new.interpret(prompt)

    data = JSON.parse(response.body)
    command_text = data["choices"][0]["message"]["content"]
    command = JSON.parse(command_text)

    validator = FabricationCommandValidator.new

    unless validator.valid?(command)
      raise InvalidFabricationCommandError, "Invalid fabrication command"
    end

    FabricationService.new.create_cube(command["size_mm"])
  rescue JSON::ParserError
    raise InvalidAIResponseError, "Orko returned malformed JSON"
  end
end
