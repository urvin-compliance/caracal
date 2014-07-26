require 'spec_helper'

describe Caracal::Errors do
  
  # existence checks
  it { expect(Caracal::Errors::InvalidPageNumberError).not_to be_nil }
  it { expect(Caracal::Errors::InvalidPageSettingError).not_to be_nil }
  it { expect(Caracal::Errors::NoBlockGivenError).not_to be_nil }
  it { expect(Caracal::Errors::NoDocumentError).not_to be_nil }

end