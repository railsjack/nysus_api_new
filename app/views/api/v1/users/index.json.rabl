object @user

attributes :id,
    :email

child :establishments do
    attributes :id, :name
end