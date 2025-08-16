# 🛍️ E-Commerce App (Flutter)

A modern and responsive **Flutter-based E-Commerce application** with product listing, product details, admin mode, and order management features.  
This project was developed as part of the assignment requirements.

---

## 🎥 Demo
<a href="https://github.com/srivishnu-2001/ecommerceapp/blob/main/video.mp4">
  <img src="https://github.com/srivishnu-2001/ecommerceapp/blob/main/image.jpg" alt="Watch the video" width="350" height="600">
</a>  

Click the image to watch the demo video.

---

## ✨ Features

### 1. Product Listing Page
- Products fetched from **[DummyJSON API](https://dummyjson.com/products/category/all?limit=200')**
- Displays:
  - Product image
  - Title
  - Price
  - Category
- **Filter by category** (Fashion, Food, Appliances, Books, Electronics)
- **Sorting options** (by Price, Name)

### 2. Product Detail Page
- Tap on a product to view details
- Shows:
  - Title
  - Description
  - Brand
  - Rating
  - Stock availability

### 3. Admin Mode
- Toggle switch to switch between **User** and **Admin**
- In **Admin Mode**:
  - “Add Product” button available
  - Form modal for adding a new product (title, price, category, image URL)
  - Added products appear in the product list (**local state only**, no API submission)

### 4. Responsive Design
- Adaptive layout for both **mobile** and **tablet/desktop**
- Built with Flutter’s responsive UI widgets

### 5. Order Management
- Orders are saved using **SharedPreferences**
- User can view past orders with details:
  - Items purchased
  - Quantity & price breakdown
  - Delivery info (name, phone, address)
  - Order date

---

## 🛠️ Tech Stack

- **Flutter** (3.x)
- **Dart** (3.x)
- **Provider** (State Management)
- **SharedPreferences** (Local storage for orders)
- **CachedNetworkImage** (Efficient image caching)
- **DummyJSON API** (Product data)

---

## 📂 Project Structure

