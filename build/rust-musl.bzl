load("@rules_rust//rust:rust.bzl", "rust_binary")

def _impl(settings, attr):
    _ignore = (settings, attr)
    return {"//command_line_option:platforms": "//build/platform:musl"}

_musl_platform_transition = transition(
    implementation = _impl,
    inputs = [],
    outputs = ["//command_line_option:platforms"],
)

# The implementation of transition_rule: all this does is copy the
# rust_binary's output to its own output and propagate its runfiles.
def _transition_rule_impl(ctx):
    actual_binary = ctx.attr.actual_binary[0]
    outfile = ctx.actions.declare_file(ctx.label.name)
    rust_binary_outfile = actual_binary[DefaultInfo].files.to_list()[0]
    ctx.actions.run_shell(
        inputs = [rust_binary_outfile],
        outputs = [outfile],
        command = "cp %s %s" % (rust_binary_outfile.path, outfile.path),
    )
    return [DefaultInfo(
        files = depset([outfile]),
        data_runfiles = actual_binary[DefaultInfo].data_runfiles,
    )]

_transition_rule = rule(
    implementation = _transition_rule_impl,
    attrs = {
        # Outgoing edge transition
        "actual_binary": attr.label(cfg = _musl_platform_transition),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)

def rust_musl(name, visibility, **kwargs):
    binary_name = name + "_binary"
    _transition_rule(
        name = name,
        actual_binary = ":%s" % binary_name,
    )
    rust_binary(
        name = binary_name,
        target_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
            "//build/platform/libc:musl",
        ],
        **kwargs
    )
