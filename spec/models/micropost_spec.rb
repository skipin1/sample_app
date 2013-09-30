# encoding: utf-8

require 'spec_helper'

describe Micropost do
  
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject {@micropost}

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "когда user_id не указан" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "атрибуты доступа" do
    it "не должно быть доступа к user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "когда user_id не сужествует" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "с пустым полем КОНТЕНТ" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "когда контент слишком большой" do
    before { @micropost.content = "a"*141 }
    it { should_not be_valid }
  end
end
