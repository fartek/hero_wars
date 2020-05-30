defmodule Support.TestUtils do
  @moduledoc """
  Various utilities that make tests more clean and easier to read.
  """

  alias ExUnit.Callbacks

  @doc """
  Sets the value of a specific key in the config. Only valid for the duration of the test
  and is reset once the test terminates.
  """
  def set_temp_config(config_property, new_value, opts \\ []) do
    application =
      opts[:application] || Application.get_env(:hero_wars, :test_utils)[:default_otp_app]

    if is_nil(application) do
      raise """
      Application not provided. Include it in the opts param as :application, or set a :default_otp_app in the config
      """
    end

    original_config = Application.get_env(application, config_property)
    Application.put_env(application, config_property, new_value)

    Callbacks.on_exit(fn ->
      Application.put_env(application, config_property, original_config)
    end)
  end

  @doc """
  If the value of a specific property in a config is a keyword list, temporairly updates/sets a key/value
  in the keyword list. Only valid for the duration of the test and is reset once the test terminates.
  """
  def set_temp_config_value(config_property, property_key, property_value, opts \\ []) do
    application =
      opts[:application] || Application.get_env(:hero_wars, :test_utils)[:default_otp_app]

    if is_nil(application) do
      raise """
      Application not provided. Include it in the opts param as :application, or set a :default_otp_app in the config
      """
    end

    original_config = Application.get_env(application, config_property)
    config = original_config || []
    new_config = Keyword.put(config, property_key, property_value)

    Application.put_env(application, config_property, new_config)

    Callbacks.on_exit(fn ->
      Application.put_env(application, config_property, original_config)
    end)
  end
end
