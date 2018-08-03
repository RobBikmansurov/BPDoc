# frozen_string_literal: true

require 'rails_helper'

describe Term do
  context 'validates' do
    it { should validate_uniqueness_of(:shortname) }
    it { should validate_length_of(:shortname).is_at_least(2).is_at_most(50) }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(200) }
    it { should validate_presence_of(:description) }
  end
end
