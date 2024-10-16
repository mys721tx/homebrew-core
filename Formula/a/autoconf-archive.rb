class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2024.10.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2024.10.16.tar.xz"
  sha256 "7bcd5d001916f3a50ed7436f4f700e3d2b1bade3ed803219c592d62502a57363"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ad375a956bd246edd6a9f6a08118572a33d2c0c4732e56343eb557e81ef9e762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea643bc91c9234ccfe254e4a510ef3da869c6a7497203b01a94c1c984b25dccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eff12d495e12588faaececedf65651baef736dd31af94bb3025998a2dcc35ee4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eff12d495e12588faaececedf65651baef736dd31af94bb3025998a2dcc35ee4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eff12d495e12588faaececedf65651baef736dd31af94bb3025998a2dcc35ee4"
    sha256 cellar: :any_skip_relocation, sonoma:         "57d43fd96d81578fe46bc6ddcfe4c0d79be9e50d7704b7ad0a2509ee5b5f95cd"
    sha256 cellar: :any_skip_relocation, ventura:        "241f7af27fa98b3cde170df669f5041e1af971fb4846890269d01df8ab26e74b"
    sha256 cellar: :any_skip_relocation, monterey:       "241f7af27fa98b3cde170df669f5041e1af971fb4846890269d01df8ab26e74b"
    sha256 cellar: :any_skip_relocation, big_sur:        "241f7af27fa98b3cde170df669f5041e1af971fb4846890269d01df8ab26e74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "270f3e443b7e742f7cd0c6e2c1882d1f6d2912008549a9f8166ea4c0a501b7e2"
  end

  # autoconf-archive is useless without autoconf
  depends_on "autoconf"

  conflicts_with "gnome-common", because: "both install ax_check_enable_debug.m4 and ax_code_coverage.m4"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"configure.ac").write <<~EOS
      AC_INIT([test], [0.1])
      AX_CHECK_ENABLE_DEBUG
      AC_OUTPUT
    EOS

    system Formula["autoconf"].bin/"autoconf", "configure.ac"
    assert_path_exists testpath/"autom4te.cache"
  end
end
