{
  inputs,
  outputs,
  ...
}: {
  # Adds my packages (./pkgs) into the overlay namespace
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # Reserved for upstream patches / overrides; empty for now
  modifications = _final: _prev: {
  };
}
