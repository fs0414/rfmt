use crate::error::{Result, RfmtError};

/// Validate source code size
pub fn validate_source_size(source: &str, max_size: u64) -> Result<()> {
    let size = source.len() as u64;

    if size > max_size {
        return Err(RfmtError::UnsupportedFeature {
            feature: "Large file".to_string(),
            explanation: format!(
                "Source code is too large ({} bytes, max {} bytes)",
                size, max_size
            ),
        });
    }

    Ok(())
}
