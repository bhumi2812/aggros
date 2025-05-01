-- Update users table to add phone field
ALTER TABLE users ADD COLUMN phone VARCHAR(20) AFTER name;

-- Update existing users with default phone number if needed
UPDATE users SET phone = '' WHERE phone IS NULL;

-- Add address column to users table
ALTER TABLE users ADD COLUMN address VARCHAR(255) AFTER phone;

-- Update existing records to have empty strings for phone and address if they are null
UPDATE users SET phone = '' WHERE phone IS NULL;
UPDATE users SET address = '' WHERE address IS NULL; 