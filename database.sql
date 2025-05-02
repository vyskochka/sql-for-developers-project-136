CREATE TABLE lessons (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  video_link TEXT,
  position INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  update_at TIMESTAMP NOT NULL,
  course_link TEXT NOT NULL
);

CREATE TABLE courses (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  update_at TIMESTAMP NOT NULL
);

CREATE TABLE modules (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  update_at TIMESTAMP NOT NULL
);

CREATE TABLE programs (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  price INT NOT NULL,
  program_type VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL,
  update_at TIMESTAMP NOT NULL
);

CREATE TABLE users (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  username VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('student', 'teacher', 'admin')),
  password_hash VARCHAR(255) NOT NULL,
  teaching_group_id INT REFERENCES TeachingGroups (id) ON DELETE SET NULL,
  created_at TIMESTAMP NOT NULL,
  update_at TIMESTAMP NOT NULL,
);

CREATE TABLE teachingGroups (
  id SERIAL PRIMARY KEY,
  slug VARCHAR(50) UNIQUE NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE enrollments (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT REFERENCES users(id),
  program_id INT REFERENCES programs(id),
  status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'pending', 'cancelled', 'completed')),
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  UNIQUE (user_id, program_id)  -- ЧТОБ НЕ ПОДПИСЫВАЛИСЬ ДВАЖДЫ
);

CREATE TABLE payments (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  enrollment_id INT REFERENCES enrollments(id),
  amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0), -- 10 цифр, 2 знака после запятой
  status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'paid', 'failed', 'refunded')),
  payment_date TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE programCompletions (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  program_id INT REFERENCES programs(id),
  status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'completed', 'pending', 'cancelled')),
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  UNIQUE (user_id, program_id)  -- опять убраем дубликаты таким образом
);

CREATE TABLE certificates (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT REFERENCES users(id),
  program_id INT REFERENCES programs(id),
  url TEXT NOT NULL,
  issue_date TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  UNIQUE (user_id, program_id)
);

CREATE TABLE quizzes (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id INT NOT NULL REFERENCES lessons(id),
  title VARCHAR(255) NOT NULL,
  content JSONB NOT NULL, 
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE exercises (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id INT NOT NULL REFERENCES lessons(id),
  title VARCHAR(255) NOT NULL,
  url TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE discussions (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id INT NOT NULL REFERENCES lessons(id),
  content TEXT NOT NULL,
  author_id INTEGER NOT NULL REFERENCES users(id),
  parent_id INTEGER REFERENCES discussions(id), -- для древовидных комментариев
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE blogPosts (
  id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT NOT NULL REFERENCES users(id),
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('created', 'in_moderation', 'published', 'archived')),
  slug TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP NOT NULL,
  published_at TIMESTAMP,
  updated_at TIMESTAMP NOT NULL
);

