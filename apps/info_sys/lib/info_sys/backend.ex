defmodule InfoSys.Backend do
  @callback name() :: String.t()
  @callback compute(query :: String.t(), opts :: Keyword.t())
    :: [InfoSys.Result.t()]
end

# 8R4Y4L-95G2LV78E5
