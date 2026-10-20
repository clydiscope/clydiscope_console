class FabricationCommandValidator
  def valid?(command)
    command["operation"] == "create_cube" &&
      command["size_mm"].is_a?(Numeric) &&
      command["size_mm"] > 0 &&
      command["size_mm"] <= 200
  end
end