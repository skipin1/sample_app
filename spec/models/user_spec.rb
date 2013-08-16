# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do
  before do
  	@user = User.new(name: "Example User", email: "example@domen.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

# Проверка имени
  describe "когда имя не существует" do
  	before {@user.name = " "}
  	it {should_not be_valid}
  end

  describe "когда имя слишком большое (длинное)" do
    before {@user.name = "a"*51}
    it{should_not be_valid}
  end

# Проверка email
  describe "когда email не существует" do
    before {@user.email = " "}
    it {should_not be_valid}
  end

  describe "когда email формат НЕ ПРАВИЛЬНЫЙ" do
    it "должен быть не правильным" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "когда email формат правильный" do
    it "должен быть ПРАВИЛЬНЫЙ"  do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "когда email уже существует" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it{should_not be_valid}
  end

# Пароль
  describe "когда пароль не существует" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "когда пароль не соответствует подтверждению" do
    before { @user.password_confirmation = "mismatch" }
    it{should_not be_valid}
  end

  describe "когда подтверждение пароля является nil" do
    before {@user.password_confirmation = nil}
    it {should_not be_valid}
  end

  describe "кгда пароль слишком короткий" do
    before {@user.password = @user.password_confirmation = "a"*5}
    it {should be_invalid}
  end

# Аутентификация
  describe "возвращает значение метода аутентификации" do
    before {@user.save}
    let(:found_user) {User.find_by_email(@user.email)}

    describe "с правильным значением" do
      it {should == found_user.authenticate(@user.password)}
    end

    describe "с не правильным значением" do
      let (:user_for_invalid_password) {found_user.authenticate("invalid")}

      it {should_not == user_for_invalid_password}
      specify {user_for_invalid_password.should be_false}
    end
  end
end
