class CreateContacts < ActiveRecord::Migration

  def change
    create_table :contacts do |t|
      t.string   :name
      t.string   :sex
      t.integer  :age
      t.date     :birthday
      t.string   :phone
      t.string   :email

      # Address attributes
      t.string   :street
      t.string   :city
      t.string   :state
      t.string   :postal_code

      t.timestamps
    end
  end

end
