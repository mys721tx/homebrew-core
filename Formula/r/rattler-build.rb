class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://github.com/prefix-dev/rattler-build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "dd27e423d464b65cc013bd8d5d6ed02f9589c0a56d06bad63b302b442364391c"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/rattler-build.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2560d2519da78acbc791ebda4f698a5efbc902dc8b5f242d2a853baccac88c21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "043b487cc9dbcd253a91df27e578d5f9aeeb7bf78f30b3e930cdf630c6172024"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "644c0245b221b260c81eabca7b4f9e3f830b942dc7e4731c4ccd3aa9dddc89b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "81d016eea2556b768fc0c59cf64b329784dd2bedbc7d0a49af344d50fb7b6fae"
    sha256 cellar: :any_skip_relocation, ventura:       "8b54c67b8e5c0e49b56914e2c9dbfd643a6647f6c3a2b3af42e8caa73517d9af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "427079817939feb0a26c214f8004c1f0cb4a6abc7b0a0810368a5c57bad2afd1"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--features", "tui", *std_cargo_args

    generate_completions_from_executable(bin/"rattler-build", "completion", "--shell")
  end

  test do
    (testpath/"recipe"/"recipe.yaml").write <<~EOS
      package:
        name: test-package
        version: '0.1.0'

      build:
        noarch: generic
        string: buildstring
        script:
          - mkdir -p "$PREFIX/bin"
          - echo "echo Hello World!" >> "$PREFIX/bin/hello"
          - chmod +x "$PREFIX/bin/hello"

      requirements:
        run:
          - python

      tests:
        - script:
          - test -f "$PREFIX/bin/hello"
          - hello | grep "Hello World!"
    EOS
    system bin/"rattler-build", "build", "--recipe", "recipe/recipe.yaml"
    assert_predicate testpath/"output/noarch/test-package-0.1.0-buildstring.conda", :exist?

    assert_match version.to_s, shell_output(bin/"rattler-build --version")
  end
end
