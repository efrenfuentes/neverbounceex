# NeverBounceEx

[![Hex.pm](https://img.shields.io/hexpm/v/neverbounceex.svg)](https://hex.pm/packages/neverbounceex)

NeverBounce API Elixir wrapper. It provides helpful methods to quickly implement NeverBounce API in your Elixir applications

## Installation

To use it in your Mix projects, first add `neverbounceex` to your list of dependencies in `mix.exs`:


```elixir
def deps do
  [
    {:neverbounceex, "~> 0.1.0"}
  ]
end
```

Add `neverbounceex` as applications:

```elixir
def application do
  [
    extra_applications: [:logger, :neverbounceex]
  ]
end
```

Then run mix deps.get to install it.

## Application config

```elixir
config :neverbounceex,
  username: "your_username",
  secret_key: "your_secret_key",
```

## Using the application

Just call NeverBounceEx.single/1 with the email to validate:

```elixir
Interactive Elixir (1.5.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> NeverBounceEx.single("efrenfuentes@gmail.com")
{:ok, "valid"}
```
