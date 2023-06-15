defmodule PasswordGeneratorTest do
  use ExUnit.Case
  doctest PasswordGenerator

  test "greets the world" do
    assert PasswordGenerator.hello() == :world
  end

  setup do
    options = %{
      length: 10,
      numbers: false,
      special_chars: false,
      uppercase: false
    }
    options_type = %{
    lowercase: Enum.map(?a..?z, & <<&1>>),
    numbers: Enum.map(0..9, & Integer.to_string(&1)),
    uppercase: Enum.map(?A..?Z, & <<&1>>),
    symbols: String.split(" !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~", "", trim: true)
    }
    {:ok, result} = PasswordGenerator.generate(options)
    %{
      options_type: options_type,
      result: result
    }
  end

  test "return a string", %{result: result} do
    assert is_bitstring(result)
  end

  test "return an error" do
    options = %{ "invalid" => "false" }
    assert {:error, _} = PasswordGenerator.generate(options)
  end

  test "return a string with length 50", %{result: result} do
    options = %{"length" => "ab"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end
  test "return a string with length 10", %{result: result} do
    length = %{ "length" => "10" }
    {:ok, result} = PasswordGenerator.generate(length)
    assert String.length(result) == 10
  end
  test "return a lowercase", %{options_type: options} do
    length = %{ "length" => "10" }
    {:ok, result} = PasswordGenerator.generate(length)
    assert String.contains?(result, options.lowercase)
    refute String.contains?(result, options.numbers || options.uppercase || options.symbols)
  end

  test "returns errors when options values are not booleans" do
    options = %{
      length: 10,
      numbers: "invalid",
      symbols: "false",
      uppercase: "invalid"
    }
    assert {:error, _} = PasswordGenerator.generate(options)
  end
  test "returns errors when options when options are not allowed" do
    options = %{ "length" => "10", "invalid" => "true" }
    assert {:error, _} = PasswordGenerator.generate(options)
  end

  test "returns error when 1 option not allowed" do
    options = %{ "length" => "10", "numbers" => "true", "invalid" => "true" }
    assert {:error, _} = PasswordGenerator.generate(options)
  end


end
