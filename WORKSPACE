load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
    urls = [
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

RUST_COMMIT = "7de6e0a8861c507808ec594cfee02da8bc61c062"

http_archive(
    name = "rules_rust",
    patches = [
        "//:patches/rules_rust_musl_patch",
    ],
    strip_prefix = "rules_rust-%s" % RUST_COMMIT,
    urls = ["https://github.com/bazelbuild/rules_rust/archive/%s.tar.gz" % RUST_COMMIT],
)

load("@rules_rust//rust:repositories.bzl", "rust_repository_set")

rust_repository_set(
    name = "macos_musl_tuple",
    edition = "2018",
    exec_triple = "x86_64-apple-darwin",
    extra_target_triples = ["x86_64-unknown-linux-musl"],
    version = "1.53.0",
)

register_toolchains(
    "//build/toolchains:macos_musl_toolchain",
)
