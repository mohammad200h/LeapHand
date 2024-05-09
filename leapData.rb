def get_leap(prefix=nil,finger_names=["FF","MF","RF","TH"],names_space_flag=false)
  contacts =[]
  for i in 0..finger_names.length-1 do
    b1 = "knuckle_" + finger_names[i]
    b2 = "palm"
    contact = {
      "b1"=>b1,
      "b2"=>b2
    }
    contacts.push(contact)
  end


  return contacts

end
