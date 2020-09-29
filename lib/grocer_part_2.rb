require_relative './part_1_solution.rb'
require 'pry'


def apply_coupons(cart, coupons)
  cart.each do |item_hash|
    coupons.each do |coupon_hash|
      cart_item = coupon_hash[:item] == item_hash[:item] ? cart_item = item_hash : cart_item = nil
      couponed_item_name = "#{item_hash[:item]} W/COUPON" 
      cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
      if cart_item && cart_item[:count] >= coupon_hash[:num]
        if cart_item_with_coupon
          cart_item_with_coupon[:count] += coupon_hash[:num]
          cart_item[:count] -= coupon_hash[:num]
        else
          cart_item_with_coupon = {
          :item => couponed_item_name,
          :price => coupon_hash[:cost] / coupon_hash[:num],
          :clearance => item_hash[:clearance],
          :count => coupon_hash[:num]
          }
          cart << cart_item_with_coupon
          cart_item[:count] -= coupon_hash[:num]
        end
      end
    end
  end
  # binding.pry
  cart
end

# if the coupon hash has an item that matches a cart item 
# then change the name of the item to "item name w/ coupon"
# and change price to coupon hash cost divided by number
# add discounted item to new cart 
# add non discounted items to cart also 

def apply_clearance(cart)
  cart.each do |item_hash|
    if item_hash[:clearance] == true 
      item_hash[:price] = 0.8 * item_hash[:price].to_f
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
  post_coupon_cart = apply_coupons(consolidated, coupons)
  post_clearance_cart = apply_clearance(post_coupon_cart)
  # binding.pry
  sum = 0
  post_clearance_cart.each do |item_hash|
    sum += item_hash[:price].to_f * item_hash[:count]
  end
  # binding.pry
  if sum > 100
    discounted_sum = sum.to_f * 0.9
    return discounted_sum.round(2)
    binding.pry
  else
    return sum.round(2) 
  end
end
