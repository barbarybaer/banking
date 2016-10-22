class OnlineLendingController < ApplicationController
	def register

	end
	def create_lender
		u=Lender.new(lender_params)
		if u.save
			user = Lender.last
			session[:user_id] = user.id
			redirect_to "/online_lending/lender/#{user.id}"
		else
			flash[:errors] = u.errors.full_messages
			redirect_to "/online_lending/register"
		end
	end

	
	def create_borrower
		u=Borrower.new(borrower_params)
		if u.save
			user = Borrower.last
			session[:user_id] = user.id
			redirect_to "/online_lending/borrower/#{user.id}"
		else
			flash[:errors] = u.errors.full_messages
			redirect_to "/online_lending/register"
		end
	end
	def login
	end

	def check_login
		@user = Borrower.find_by(email: params[:email])
		if @user
			session[:user_type]='b'
		end
		if !@user
			@user = Lender.find_by(email: params[:email])
			if @user
				session[:user_type]='l'
			end
		end
		if (@user && @user.authenticate(params[:password])) 
			session[:user_id] = @user.id
			if session[:user_type] == 'b'
				@lenders = History.find_by_sql("select l.first_name, l.last_name, amount, l.email from histories h join lenders l on l.id = h.lender_id where h.borrower_id = #{@user.id} ")
				redirect_to "/online_lending/borrower/#{@user.id}"
			else 
				redirect_to "/online_lending/lender/#{@user.id}"
			end
		else
			flash[:errors] = ["Invalid email or password"]
			redirect_to '/online_lending/login'
		end



		
	end

private 
  def lender_params
    params.require(:lender).permit(:first_name, :last_name, :email, :password, :money)
  end

  def borrower_params
    params.require(:borrower).permit(:first_name, :last_name, :email, :password, :money, :purpose)
  end

end
