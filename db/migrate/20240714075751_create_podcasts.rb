class CreatePodcasts < ActiveRecord::Migration[7.0]
  def change
    create_table :podcasts do |t|
      t.string :name,      null: false
      t.text   :discription, null: false
      t.timestamps

      has_one_attached :image
    end
  end
end
