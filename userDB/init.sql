CREATE TABLE "Users" (
    "UserId" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "Username" VARCHAR NOT NULL UNIQUE,
    "FullName" VARCHAR NOT NULL,
    "Email" VARCHAR NOT NULL UNIQUE,
    "PasswordHash" VARCHAR NOT NULL,
    "UserType" VARCHAR NOT NULL CHECK ("UserType" IN ('Trainer', 'Trainee')),
    "CreatedAt" TIMESTAMP DEFAULT NOW(),
    "LastLoginAt" TIMESTAMP NULL,
    "createdAt" TIMESTAMP NOT NULL,
    "updatedAt" TIMESTAMP NOT NULL
);
