defmodule FallbackCommand do
  use Prompt.Command

  @impl true
  def init(_argv) do
    %{}
  end

  @impl true
  def process(_) do
    display("fallback command")
  end
end

defmodule ExampleCommand do
  use Prompt.Command

  @impl true
  def init(_argv) do
    %{}
  end

  @impl true
  def process(_) do
    display("test command")
  end
end

defmodule Example do
  use Prompt.Router, otp_app: :prompt

  command :test, ExampleCommand do
    arg(:help, :boolean)
  end

  command "", FallbackCommand do
    arg(:help, :boolean)
  end

  @impl true
  def help do
    display("help")
  end
end

defmodule PromptModuleTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "show help" do
    assert capture_io(fn ->
             Example.main(["--help"])
           end) =~ "help"
  end

  test "subcommand" do
    assert capture_io(fn ->
             Example.main(["test"])
           end) =~ "test command"
  end

  test "unknown command" do
    assert capture_io(fn ->
             Example.main(["whatever"])
           end) =~ "Unrecognized option - whatever"
  end

  test "fallback" do
    assert capture_io(fn ->
             Example.main([])
           end) =~ "fallback command"
  end
end
