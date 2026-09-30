/**
 * Node.js Firestore Seeder Script for Aramielle Restaurant
 * Project: aramielle-f0523
 *
 * Instructions:
 * 1. Open Firebase Console -> Project Settings -> Service Accounts
 * 2. Click "Generate new private key" and save as serviceAccountKey.json in this folder.
 * 3. Run: npm install
 * 4. Run: node seed_firestore.js
 */

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

const keyPath = path.join(__dirname, 'serviceAccountKey.json');

if (!fs.existsSync(keyPath)) {
  console.error('\n[ERROR] serviceAccountKey.json not found!');
  console.error('Please download your Firebase Admin Service Account key from:');
  console.error('https://console.firebase.google.com/project/aramielle-f0523/settings/serviceaccounts/adminsdk');
  console.error('and save it as serviceAccountKey.json inside:');
  console.error(__dirname + '\n');
  process.exit(1);
}

const serviceAccount = require(keyPath);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'aramielle-f0523'
});

const db = admin.firestore();

// 1. MENU ITEMS DATA (20 Categories, 50+ Dishes)
const menuItems = [
  // STEAK
  { id: 'st_1', name: 'Rib Eye Steak', description: 'Rice or mashed potato, buttered vegetables.', price: 580.0, cuisine: 'Steak', allergens: ['Dairy'], ingredients: ['Rib Eye Beef', 'Butter', 'Vegetables', 'Rice/Potato'], imageUrl: 'https://images.unsplash.com/photo-1600891964092-4316c288032e?w=500' },
  { id: 'st_2', name: 'T-Bone Steak', description: 'Rice or mashed potato, buttered vegetables.', price: 495.0, cuisine: 'Steak', allergens: ['Dairy'], ingredients: ['T-Bone Beef', 'Butter', 'Vegetables', 'Rice/Potato'], imageUrl: 'https://images.unsplash.com/photo-1558030006-450675393462?w=500' },
  { id: 'st_3', name: 'Grilled Salmon Steak', description: 'Fresh Salmon, Rosemary, Garlic, olive oil, buttered vegetables.', price: 449.0, cuisine: 'Steak', allergens: ['Fish', 'Dairy'], ingredients: ['Fresh Salmon', 'Rosemary', 'Garlic', 'Olive Oil', 'Buttered Vegetables'], imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500' },

  // SALAD
  { id: 'sl_1', name: 'Aramielle Salad', description: 'Lettuce, dried tomato, feta cheese, olives, walnuts, chicken popcorn, vinaigrette.', price: 300.0, cuisine: 'Salad', allergens: ['Dairy', 'Tree Nuts'], ingredients: ['Lettuce', 'Dried Tomato', 'Feta Cheese', 'Olives', 'Walnuts', 'Chicken Popcorn', 'Vinaigrette'], imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500' },
  { id: 'sl_2', name: 'Kani Salad', description: 'Lettuce, mango, crab stick, carrot, tomato, onion, kewpie.', price: 270.0, cuisine: 'Salad', allergens: ['Shellfish', 'Eggs'], ingredients: ['Lettuce', 'Mango', 'Crab Stick', 'Carrot', 'Tomato', 'Onion', 'Kewpie Mayonnaise'], imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500' },

  // APPETIZERS
  { id: 'ap_1', name: 'Quesadilla', description: 'Toasted tortilla filled with melted cheese and savory filling.', price: 280.0, cuisine: 'Appetizers', allergens: ['Dairy', 'Gluten'], ingredients: ['Tortilla', 'Cheese', 'Seasoned Meat', 'Spices'], imageUrl: 'https://images.unsplash.com/photo-1618040996337-56904b7850b9?w=500' },
  { id: 'ap_2', name: 'Chicken Fingers', description: 'Crispy breaded chicken strips served with dip.', price: 150.0, cuisine: 'Appetizers', allergens: ['Gluten', 'Eggs'], ingredients: ['Chicken Breast Strips', 'Breadcrumbs', 'Dip Sauce'], imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=500' },

  // PASTA
  { id: 'pa_1', name: 'Seafood Pesto', description: 'Shrimp, mussels, calamari, fresh basil pesto, parmesan.', price: 280.0, cuisine: 'Pasta', allergens: ['Shellfish', 'Dairy', 'Gluten'], ingredients: ['Shrimp', 'Mussels', 'Calamari', 'Fresh Pesto', 'Parmesan', 'Pasta'], imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3d5d6281318?w=500' },
  { id: 'pa_2', name: 'Carbonara', description: 'Bacon, rich cream sauce, parmesan cheese, pecorino, spaghettini pasta.', price: 285.0, cuisine: 'Pasta', allergens: ['Dairy', 'Gluten', 'Eggs'], ingredients: ['Bacon', 'Parmesan Cheese', 'Pecorino', 'Spaghettini Pasta', 'Cream'], imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=500' },

  // PIZZA
  { id: 'pz_1', name: 'Aramielle Signature Pizza', description: 'Olives, pineapple, peppers, tomato, marinara sauce, mozzarella cheese, pepperoni.', price: 390.0, cuisine: 'Pizza', allergens: ['Dairy', 'Gluten'], ingredients: ['Olives', 'Pineapple', 'Peppers', 'Tomato', 'Marinara Sauce', 'Mozzarella Cheese', 'Pepperoni'], imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500' },
  { id: 'pz_2', name: 'Pepperoni Pizza', description: 'Classic sliced pepperoni, mozzarella cheese, rich marinara sauce.', price: 360.0, cuisine: 'Pizza', allergens: ['Dairy', 'Gluten'], ingredients: ['Pepperoni', 'Mozzarella Cheese', 'Marinara Sauce'], imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=500' },

  // MAIN DISHES
  { id: 'md_1', name: 'Signature Bulalo', description: 'Traditional Batangas beef shank soup boiled to perfection with corn and cabbage.', price: 380.0, cuisine: 'Main Dishes', allergens: [], ingredients: ['Beef Shank', 'Bone Marrow', 'Corn', 'Pechay', 'Cabbage'], imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500' },
  { id: 'md_2', name: 'Crispy Pata', description: 'Deep-fried pork knuckle cooked to golden crackling perfection with garlic soy-vinegar dip.', price: 980.0, cuisine: 'Main Dishes', allergens: ['Soy', 'Gluten'], ingredients: ['Pork Knuckle', 'Garlic', 'Soy Sauce', 'Vinegar'], imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500' },

  // COFFEE & DRINKS
  { id: 'cf_1', name: 'Spanish Latte', description: 'Espresso with sweetened condensed milk and steamed fresh milk.', price: 135.0, cuisine: 'Coffee', allergens: ['Dairy'], ingredients: ['Espresso', 'Condensed Milk', 'Fresh Milk'], imageUrl: 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=500' },
  { id: 'dr_1', name: 'Cucumber Lemonade Pitcher', description: 'Refreshing chilled pitcher of fresh cucumber and sweet lemonade.', price: 200.0, cuisine: 'Drinks', allergens: [], ingredients: ['Cucumber', 'Lemon Juice', 'Honey/Sugar', 'Water'], imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=500' },

  // DESSERTS
  { id: 'ds_1', name: 'Lava Cake', description: 'Warm chocolate cake with a rich molten chocolate center served with vanilla ice cream.', price: 160.0, cuisine: 'Desserts', allergens: ['Dairy', 'Gluten', 'Eggs'], ingredients: ['Dark Chocolate', 'Butter', 'Flour', 'Eggs', 'Vanilla Ice Cream'], imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500' }
];

// 2. 30 TABLES DATA
const tables = Array.from({ length: 30 }, (_, i) => {
  const numStr = String(i + 1).padStart(2, '0');
  return {
    id: numStr,
    name: `Table ${numStr}`,
    capacity: 4,
    isOccupied: i === 1 || i === 4, // Pre-occupy Table 02 and Table 05
    occupiedByUserId: i === 1 ? 'u_999' : (i === 4 ? 'u_888' : null),
    occupiedByUserEmail: i === 1 ? 'customer_b@example.com' : (i === 4 ? 'customer_c@example.com' : null),
    occupiedByUserName: i === 1 ? 'Customer B' : (i === 4 ? 'Customer C' : null),
  };
});

async function seedFirestore() {
  console.log('🚀 Starting Aramielle Restaurant Firestore Seeding...');

  // Seed Menu Items
  console.log('📦 Seeding Menu Items...');
  const menuBatch = db.batch();
  menuItems.forEach(item => {
    const docRef = db.collection('menu_items').doc(item.id);
    menuBatch.set(docRef, item, { merge: true });
  });
  await menuBatch.commit();
  console.log(`✅ ${menuItems.length} Menu Items seeded successfully!`);

  // Seed 30 Tables
  console.log('🪑 Seeding 30 Restaurant Tables...');
  const tableBatch = db.batch();
  tables.forEach(table => {
    const docRef = db.collection('tables').doc(table.id);
    tableBatch.set(docRef, table, { merge: true });
  });
  await tableBatch.commit();
  console.log(`✅ 30 Restaurant Tables seeded successfully!`);

  console.log('\n🎉 ALL DATA SEEDED SUCCESSFULLY TO FIRESTORE PROJECT: aramielle-f0523!');
  process.exit(0);
}

seedFirestore().catch(err => {
  console.error('❌ Seeding failed:', err);
  process.exit(1);
});
