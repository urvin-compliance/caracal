require 'spec_helper'

describe Caracal::Errors do
  
  # existence checks
  it { expect(Caracal::Errors::InvalidModelError).not_to be_nil }
  it { expect(Caracal::Errors::NoDefaultStyleError).not_to be_nil }
  it { expect(Caracal::Errors::NoDocumentError).not_to be_nil }

end