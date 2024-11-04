//! Metadata functions
use const_format::formatcp as const_format;

#[byond_fn]
pub fn verdigris_version() -> &'static str {
    const_format!(
        "{name} v{version} ({git_hash})",
        name = env!("CARGO_PKG_NAME"),
        version = env!("CARGO_PKG_VERSION"),
        git_hash = env!("BOSION_GIT_COMMIT_SHORTHASH")
    )
}

#[byond_fn]
pub fn verdigris_features() -> &'static str {
    env!("BOSION_CRATE_FEATURES")
}

/// Cleans up any resources used by Verdigris.
#[byond_fn]
pub fn cleanup() {}
