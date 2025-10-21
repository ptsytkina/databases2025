#this script is ai generated

import csv
import random
from datetime import datetime, timedelta
from faker import Faker

# Initialize Faker for generating random names
fake = Faker()

# --- Configuration ---
NUM_SHIFTS = 1000000
NUM_MAINTENANCE_LOGS = 1000000
# Generate more events than shifts, as multiple events happen per shift
EVENTS_PER_SHIFT_AVG = 2.5
NUM_EVENTS = int(NUM_SHIFTS * EVENTS_PER_SHIFT_AVG)

print("Starting FNAF dataset generation...")

# --- Static Data based on FNAF Lore ---

locations = [
    (1, "Freddy Fazbear's Pizza (FNAF 1)", 1993),
    (2, "Freddy Fazbear's Pizza (FNAF 2)", 1987),
    (3, "Fazbear's Fright: The Horror Attraction", 2023),
    (4, "Circus Baby's Entertainment and Rental", 1995),
    (5, "Freddy Fazbear's Pizza Place (Pizzeria Simulator)", 2023)
]

animatronics = [
    (1, 'Freddy Fazbear', 'Classic', 1),
    (2, 'Bonnie the Bunny', 'Classic', 1),
    (3, 'Chica the Chicken', 'Classic', 1),
    (4, 'Foxy the Pirate Fox', 'Classic', 1),
    (5, 'Toy Freddy', 'Toy', 2),
    (6, 'Toy Bonnie', 'Toy', 2),
    (7, 'Toy Chica', 'Toy', 2),
    (8, 'Mangle', 'Toy', 2),
    (9, 'The Puppet', 'Toy', 2),
    (10, 'Balloon Boy', 'Toy', 2),
    (11, 'Springtrap', 'Springlock', 3),
    (12, 'Phantom Freddy', 'Phantom', 3),
    (13, 'Circus Baby', 'Funtime', 4),
    (14, 'Funtime Freddy', 'Funtime', 4),
    (15, 'Ballora', 'Funtime', 4),
    (16, 'Scrap Baby', 'Scrap', 5),
    (17, 'Molten Freddy', 'Scrap', 5),
]

guards = ['Mike Schmidt', 'Jeremy Fitzgerald', 'Fritz Smith', 'Michael Afton', 'Unnamed Guard']
outcomes = ['Survived', 'Survived', 'Survived', 'Terminated', 'Deceased']
maintenance_actions = ['Endoskeleton repair', 'Suit cleaning', 'Voice box replacement', 'System diagnostics', 'Joint lubrication', 'Power cell swap']
event_types = ['Movement', 'Audio Disturbance', 'Jumpscare Attempt', 'System Malfunction', 'Camera Disabled']
camera_locations = ['CAM 1A', 'CAM 1B', 'CAM 2A', 'CAM 2B', 'CAM 03', 'CAM 04', 'CAM 05', 'CAM 06', 'CAM 07', 'West Hall', 'East Hall', 'Parts/Service']

# --- Generate Reference Tables ---

# 1. locations.csv
with open('locations.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['location_id', 'location_name', 'established_year'])
    writer.writerows(locations)
print("✅ locations.csv generated.")

# 2. animatronics.csv
with open('animatronics.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['animatronic_id', 'animatronic_name', 'model_series', 'initial_location_id'])
    writer.writerows(animatronics)
print("✅ animatronics.csv generated.")


# --- Generate Large Tables ---

# 3. security_shifts.csv
with open('security_shifts.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['shift_id', 'location_id', 'guard_name', 'shift_start', 'shift_end', 'outcome'])
    start_date = datetime(1987, 1, 1)
    for i in range(1, NUM_SHIFTS + 1):
        location_id = random.choice([loc[0] for loc in locations])
        guard_name = random.choice(guards)
        # Shifts are from 12 AM to 6 AM
        shift_day = start_date + timedelta(days=i//5, hours=random.randint(0,12))
        shift_start = shift_day.replace(hour=0, minute=0, second=0)
        shift_end = shift_start + timedelta(hours=6)
        outcome = random.choices(outcomes, weights=[0.6, 0.6, 0.6, 0.2, 0.1], k=1)[0]
        writer.writerow([i, location_id, guard_name, shift_start.isoformat(), shift_end.isoformat(), outcome])
print(f"✅ security_shifts.csv generated with {NUM_SHIFTS} rows.")

# 4. maintenance_logs.csv
with open('maintenance_logs.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['log_id', 'animatronic_id', 'technician_name', 'service_date', 'maintenance_action', 'cost'])
    log_date = datetime(1985, 1, 1)
    for i in range(1, NUM_MAINTENANCE_LOGS + 1):
        animatronic_id = random.choice([a[0] for a in animatronics])
        technician_name = fake.name()
        service_date = log_date + timedelta(days=i//10)
        action = random.choice(maintenance_actions)
        cost = round(random.uniform(50.0, 1500.0), 2)
        writer.writerow([i, animatronic_id, technician_name, service_date.date().isoformat(), action, cost])
print(f"✅ maintenance_logs.csv generated with {NUM_MAINTENANCE_LOGS} rows.")

# 5. animatronic_events.csv
with open('animatronic_events.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['event_id', 'shift_id', 'animatronic_id', 'event_timestamp', 'camera_location', 'event_type'])
    for i in range(1, NUM_EVENTS + 1):
        shift_id = random.randint(1, NUM_SHIFTS)
        animatronic_id = random.choice([a[0] for a in animatronics])
        # Generate a random timestamp within a 6-hour shift
        event_time = datetime(2000, 1, 1, 0, 0, 0) + timedelta(minutes=random.randint(1, 359))
        camera = random.choice(camera_locations)
        event = random.choice(event_types)
        writer.writerow([i, shift_id, animatronic_id, event_time.time().isoformat(), camera, event])
print(f"✅ animatronic_events.csv generated with {NUM_EVENTS} rows.")

print("\nAll files generated successfully! You can now import them into your SQL database.")