class ConsoleResponder
  def initialize(prompt)
    @prompt = prompt
  end

  def call
    {
      status: "complete",
      timestamp: Time.current.strftime("%Y-%m-%d %H:%M:%S"),
      text: "You entered: #{@prompt}"
    }
  end
end