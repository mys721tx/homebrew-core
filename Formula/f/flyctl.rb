class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.30",
      revision: "e2b1fcaaa44eedb1e66490c63e18cc4707eeea7c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f7cd03a9cb57ffb87694121b055ec4bd5d0cf69875c1558206c69084889b35e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f7cd03a9cb57ffb87694121b055ec4bd5d0cf69875c1558206c69084889b35e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f7cd03a9cb57ffb87694121b055ec4bd5d0cf69875c1558206c69084889b35e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a19c5954c28cc1d665e3a101dccfec648549f5530835c009afd88ca254cdf659"
    sha256 cellar: :any_skip_relocation, ventura:       "a19c5954c28cc1d665e3a101dccfec648549f5530835c009afd88ca254cdf659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8980c5ba6377e295cc0fc40d49e0c70caabb9bc738a74afe0e5396a478186b3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion", base_name: "fly")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
