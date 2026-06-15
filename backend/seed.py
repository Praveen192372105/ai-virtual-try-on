import os
import sys

# Add the parent directory to sys.path so we can import from app
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy.orm import Session
from app.database import engine, SessionLocal, Base
from app.models.product import Product

# Ensure tables exist
Base.metadata.create_all(bind=engine)

products_data = [
    # ── MEN CATEGORY ──────────────────────────────────────────
    {
        "name": "Futuristic Cyber Jacket",
        "brand": "CyberWear",
        "category": "Men",
        "description": "High-collared waterproof jacket with integrated LED piping and carbon fiber shell overlay. Perfect for neon-drenched rainy streets.",
        "price": 129.99,
        "image_url": "/uploads/cyber_jacket.jpg"
    },
    {
        "name": "Vaporwave Tech Sneakers",
        "brand": "RetroFutura",
        "category": "Men",
        "description": "Retro-modern hybrid running shoes featuring glowing cushion soles and dynamic micro-mesh upper weave.",
        "price": 110.00,
        "image_url": "/uploads/vaporwave_sneakers.jpg"
    },
    {
        "name": "Synthwave Bomber Jacket",
        "brand": "SynthAesthetics",
        "category": "Men",
        "description": "Satin-finished lightweight bomber jacket depicting digital sun grids and laser wireframes in deep violet shades.",
        "price": 95.00,
        "image_url": "/uploads/synthwave_bomber.jpg"
    },
    {
        "name": "Stealth Cargo Pants",
        "brand": "ShadowOPS",
        "category": "Men",
        "description": "Tactical water-resistant cargo pants with magnetic clasp pockets and adjustable ankle straps for modular fit.",
        "price": 89.99,
        "image_url": "/uploads/stealth_cargos.jpg"
    },
    {
        "name": "Grid Runner Jersey",
        "brand": "CyberWear",
        "category": "Men",
        "description": "Athletic-fit compression jersey with printed neon circuitry patterns that shimmer under ambient strobe lights.",
        "price": 45.50,
        "image_url": "/uploads/grid_jersey.jpg"
    },

    # ── WOMEN CATEGORY ────────────────────────────────────────
    {
        "name": "Holographic Silk Dress",
        "brand": "NeoCouture",
        "category": "Women",
        "description": "Breathtaking flowing silk dress utilizing light-reflective nano-fabrics to shimmer in spectrums of cyan and pastel magenta.",
        "price": 159.50,
        "image_url": "/uploads/holo_dress.jpg"
    },
    {
        "name": "Cyberpunk Utility Skirt",
        "brand": "ShadowOPS",
        "category": "Women",
        "description": "Modular techwear skirt built with high-density nylon webbing, asymmetrical cargo sidebags, and gunmetal quick-release buckles.",
        "price": 75.00,
        "image_url": "/uploads/utility_skirt.jpg"
    },
    {
        "name": "Prism Shell Trenchcoat",
        "brand": "NeoCouture",
        "category": "Women",
        "description": "Ultra-light translucent trenchcoat with iridescent prism shell coating, storm-flaps, and deep-pouch utility pockets.",
        "price": 145.00,
        "image_url": "/uploads/prism_coat.jpg"
    },
    {
        "name": "Nexus Seamless Bodysuit",
        "brand": "NeuroFit",
        "category": "Women",
        "description": "Ultra-stretch breathable compression bodysuit with thermal-regulating fibers and sleek reflective circuit track stripes.",
        "price": 68.00,
        "image_url": "/uploads/nexus_bodysuit.jpg"
    },
    {
        "name": "Aero Mesh Crop Top",
        "brand": "NeuroFit",
        "category": "Women",
        "description": "Double-layered mesh crop top designed for maximum ventilation and active style in hot urban climates.",
        "price": 38.00,
        "image_url": "/uploads/aero_crop.jpg"
    },

    # ── KIDS CATEGORY ──────────────────────────────────────────
    {
        "name": "Neon Street Hoodie",
        "brand": "MiniGrid",
        "category": "Kids",
        "description": "Ultra-soft cotton blend kids hoodie with brilliant glow-in-the-dark cyber graphics on the sleeves and chest.",
        "price": 79.99,
        "image_url": "/uploads/kids_neon_hoodie.jpg"
    },
    {
        "name": "Pixel Glitch Tee",
        "brand": "RetroFutura",
        "category": "Kids",
        "description": "Comfortable 100% organic cotton graphic tee showing animated retro arcade pixel art with high-density printing.",
        "price": 28.50,
        "image_url": "/uploads/kids_pixel_tee.jpg"
    },
    {
        "name": "Cyber Jogger Pants",
        "brand": "MiniGrid",
        "category": "Kids",
        "description": "Lightweight athletic jogger pants with elastic neon drawcords and reinforced knee panels for active play.",
        "price": 42.00,
        "image_url": "/uploads/kids_joggers.jpg"
    },
    {
        "name": "Chibi Robot Sweatshirt",
        "brand": "SynthAesthetics",
        "category": "Kids",
        "description": "Fun and cozy fleece sweatshirt featuring a cute chibi robot avatar graphic on the front panel.",
        "price": 49.99,
        "image_url": "/uploads/kids_robot_sweatshirt.jpg"
    },
    {
        "name": "Aero Sprint Shoes",
        "brand": "RetroFutura",
        "category": "Kids",
        "description": "Slip-on kids mesh sneakers with super lightweight soles and customizable light-up neon heel modules.",
        "price": 59.99,
        "image_url": "/uploads/kids_sprint_shoes.jpg"
    },

    # ── ACCESSORIES CATEGORY ──────────────────────────────────
    {
        "name": "Chrono Smart Eyewear",
        "brand": "OptixTech",
        "category": "Accessories",
        "description": "Smart augmented reality sunglasses with transparent polarized lenses, HUD projection display, and touch temples.",
        "price": 249.00,
        "image_url": "/uploads/chrono_eyewear.jpg"
    },
    {
        "name": "Neon LED Visor",
        "brand": "OptixTech",
        "category": "Accessories",
        "description": "Cyberpunk wrap-around face visor with customizable RGB illumination modes and rechargeable battery module.",
        "price": 65.00,
        "image_url": "/uploads/led_visor.jpg"
    },
    {
        "name": "Neural Tech Backpack",
        "brand": "ShadowOPS",
        "category": "Accessories",
        "description": "Sleek geometric hard-shell backpack equipped with integrated USB charging hubs and water-resistant laptop sleeve.",
        "price": 120.00,
        "image_url": "/uploads/neural_backpack.jpg"
    },
    {
        "name": "Quantum Smart Ring",
        "brand": "NeuroFit",
        "category": "Accessories",
        "description": "Titanium smart ring containing biometric heart-rate trackers and NFC contact-sharing capabilities in a polished finish.",
        "price": 139.99,
        "image_url": "/uploads/quantum_ring.jpg"
    },
    {
        "name": "Cyber Mask V2",
        "brand": "ShadowOPS",
        "category": "Accessories",
        "description": "High-filtration face cover with customizable front glow vent and magnetic clip-straps for secure urban fit.",
        "price": 34.99,
        "image_url": "/uploads/cyber_mask.jpg"
    }
]

def seed_database():
    db: Session = SessionLocal()
    try:
        # Check if database is already seeded
        existing_count = db.query(Product).count()
        if existing_count > 0:
            print(f"Database already contains {existing_count} products. Skipping seeding.")
            return

        print("Seeding 20 premium products into SQLite database...")
        for prod in products_data:
            db_prod = Product(
                name=prod["name"],
                brand=prod["brand"],
                category=prod["category"],
                description=prod["description"],
                price=prod["price"],
                image_url=prod["image_url"]
            )
            db.add(db_prod)
        db.commit()
        print("Success! Database seeded successfully.")
    except Exception as e:
        print(f"Error seeding database: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_database()
