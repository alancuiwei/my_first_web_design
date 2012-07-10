#encoding: utf-8
require 'digest/sha2'
class Webuser < ActiveRecord::Base

  def Webuser.authenticate(name, password)
    if webuser = find_by_name(name)
      if webuser.hashed_password == encrypt_password(password, webuser.salt)
       webuser
     end
    end
  end

  def Webuser.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end

  # 'password' is a virtual attribute
  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  private
	def password_must_be_present
		errors.add(:password,"Missing password") unless hashed_password.present?
	end
    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
	
	end
