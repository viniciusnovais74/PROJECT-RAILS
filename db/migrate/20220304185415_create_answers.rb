class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.reference :question
      t.text :description
      t.boolean :correct

      t.timestamps
    end
  end
end
