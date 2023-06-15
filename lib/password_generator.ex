defmodule PasswordGenerator do
  @moduledoc """
  Documentation for `PasswordGenerator`.
  Generate random passwords depending on parameters, Module main function is `generate(options)`
  That function takes the options map.
  Option examples:
      options = %{
        length: 10,
        numbers: false,
        symbols: false,
        uppercase: false
      }
    The options are only 4, `length`, `numbers`, `symbols` and `uppercase`.

  """

  @allowed_options [  :length, :numbers, :symbols, :uppercase  ]

  @doc """
  Generate password for given options.

  ## Examples of options:
      options = %{
        length: 10,
        numbers: false,
        symbols: false,
        uppercase: false
      }
    iex > PasswordGenerator.generate(options)
      "abckdf"

     options = %{
        length: 10,
        numbers: true,
        symbols: false,
        uppercase: false
      }
      iex > PasswordGenerator.generate(options)
        "abckdf6"


  """
  @spec generate(option :: map()) :: {:ok, bitstring()} | {:error, bitstring()}
  def generate(options) do
    length = Map.has_key?(options, "length")
    validate_length(length, options)
  end

  defp validate_length(false, _options), do: {:error, "length is required"}

  defp validate_length(true, options) do
    number = Enum.map(?0..?9, & Integer.to_string(&1))
    length = options["length"]
    length = String.contains?(length, number)
    validate_length_is_integer(length, options)
  end

  defp validate_length_is_integer(false, _options) do
    {:error, "length must be an integer"}
  end

  defp validate_length_is_integer(true, options) do
    length = options["length"] |> String.trim() |> String.to_integer()
    options_without_length = Map.delete(options, "length")
    options_values = Map.values(options_without_length)
    value = options_values
    |> Enum.all?(fn x -> String.to_atoms(x) |> is_boolean() end)
    validate_options_values_are_boolean(value, length, options_without_length)
  end

  defp validate_options_values_are_boolean(false, _length, _options) do
    {:error, "options values must be booleans"}
  end
  defp validate_options_values_are_boolean(true, length, options) do
    options = included_options(options)
    invalid_options? = options |> Enum.any?(&(&1 not in @allowed_options))
    validate_option(invalid_options?, length, options)
  end

  defp included_options(options) do
    Enum.filter(options, fn {_key, value} ->
      value |>  String.trim() |> String.to_existing_atom() end)
    Enum.map(fn {key, _value} -> String.to_atom(key)} end)
  end


end
