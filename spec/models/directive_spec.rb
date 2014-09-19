require 'spec_helper'

PublicActivity.enabled = false

describe Directive do
  before(:each) do
    @directive = create(:directive)
    #stub(current_user: FactroryGirl.create(:user))
  end

  context "validates" do
    it "is valid with valid attributes: name, description" do
      expect(@directive).to be_valid
    end
  
    it "is not valid without a number" do #validates :number, :presence => true
      @directive.number = nil
      expect(@directive).not_to be_valid
    end

    it "is not valid without a name" do #validates :name, :presence => true, :length => {:minimum => 10}
      @directive.name = nil
      expect(@directive).not_to be_valid
    end

    it "is not valid if length of name < 10" do	#validates :name, :presence => true, :length => {:minimum => 10}
      @directive.name = "123456789"
      expect(@directive).not_to be_valid
      @directive.name = "1234567890"
      expect(@directive).to be_valid
    end

    it "is not valid if length of body < 2 or > 100" do  #validates :body, :length => {:minimum => 2, :maximum => 100}	# орган, утвердивший документ
      @directive.body = "1"
      expect(@directive).not_to be_valid
      @directive.body = "12"
      expect(@directive).to be_valid
      @directive.body = "a" * 100
      expect(@directive).to be_valid
      @directive.body = "b" * 101
      expect(@directive).not_to be_valid
    end
  end

  context "associations" do
    it "has_many :document, :through => :document_directive" do
      should have_many(:document).through(:document_directive) # а основании директивы может быть несколько документов
    end
    it "has_many :document_directive, :dependent => :destroy" do
      should have_many(:document_directive).dependent(:destroy) 
    end
  end  

end
