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
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should be_valid }
  it { should_not be_admin }

  describe "еслиу пользователя права admin" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "проверка аттрибутов," do
    it "не должно быть доступа к :admin" do
      expect do
        User.new(admin: 1)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

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

  describe "email в смешанном регистре" do
    let (:mixed_case_email) {"Foo@ExAMPle.CoM"}

    it "должен сохраняться в нижнем регистре" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
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

  describe "идентификатор поьзователя (куки)" do
    before {@user.save}
    its(:remember_token) { should_not be_blank }
  end

  describe "ассоцияации с mircopost" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end

    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "должны быть правильные сообщения в правильном порядке" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "должен удалить связанные микросообщения" do
      microposts = @user.microposts.dup
      @user.destroy
      microposts.should_not be_empty
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "статус" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
    end
  end
end
