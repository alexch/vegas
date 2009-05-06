helpers do
  def logged_in?
    return true if session[:user]
    nil
  end
  
  def current_user
    session[:user] || nil
  end

  # todo: test
  def flash(msg = nil)
    if msg.nil?
      if session[:flash]
        value = session[:flash]
        session[:flash] = false
        return value
      else
        return nil
      end
    else
      msg = msg + "." unless msg =~ /[\.!\?]$/  # append period if necessary
      session[:flash] = msg
    end
  end
  
  def flash?
    session[:flash] ? true : false
  end

#todo: clean up for 1-pass 
  def render_page(page)
    page.assign_locals({:current_user => current_user, :flash => flash})
    page.to_s
  end
end

