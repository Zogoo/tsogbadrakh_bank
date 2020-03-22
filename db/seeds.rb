# Exchange rates
FactoryBot.create(:exchange_rate, :usd_jpy, rate: 110_97)
FactoryBot.create(:exchange_rate, :eur_jpy, rate: 119_44)
FactoryBot.create(:exchange_rate, :usd_euro, rate: 93)
FactoryBot.create(:exchange_rate, :usd_cny, rate: 7_10)
FactoryBot.create(:exchange_rate, :eur_cny, rate: 7_64)
FactoryBot.create(:exchange_rate, :eur_gbp, rate: 92)

# All possible kind of branches
main_branch = FactoryBot.create(:branch, name: 'Main', kind: :bank)
atm_branch = FactoryBot.create(:branch, name: 'Shopping center', kind: :atm)
web_branch = FactoryBot.create(:branch, name: 'visable-bank.com', kind: :virtual)
pos_branch = FactoryBot.create(:branch, name: 'Pub', kind: :pos)
vendor_branch = FactoryBot.create(:branch, name: 'Lend.com', kind: :vendor)

def transfer_histories(account)
  5.times do
    FactoryBot.create(:transaction, :transfer, status: :completed, account: account)
  end
end

def incode_histories(account)
  5.times do
    acc = FactoryBot.create(:transaction, :transfer, status: :completed, reciever: account)
    acc.save
  end
end

def create_user_with_related_resources(branch)
  user = FactoryBot.create(:user, branch: branch)
  user.profile.save
  savings_acc = FactoryBot.create(:account, :savings, user: user)
  incode_histories(savings_acc)
  checking_acc = FactoryBot.create(:account, :checking, user: user)
  incode_histories(checking_acc)
  transfer_histories(checking_acc)
end

# Main branch users with accounts
10.times do
  create_user_with_related_resources(main_branch)
end

# Other branch users with accounts
[atm_branch, web_branch, pos_branch, vendor_branch].each do |branch|
  create_user_with_related_resources(branch)
end

