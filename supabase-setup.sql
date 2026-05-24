-- 1. 创建学习记录表
CREATE TABLE IF NOT EXISTS study_records (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  chinese DECIMAL(5,1),
  math DECIMAL(5,1),
  english DECIMAL(5,1),
  wrong_chinese INTEGER,
  wrong_math INTEGER,
  wrong_english INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- 确保每个用户每天最多一条记录
  UNIQUE(user_id, date)
);

-- 2. 启用行级安全策略
ALTER TABLE study_records ENABLE ROW LEVEL SECURITY;

-- 3. 创建策略：用户只能管理自己的记录
CREATE POLICY "Users can manage own records" ON study_records
  FOR ALL USING (auth.uid() = user_id);

-- 4. 创建索引提升查询性能
CREATE INDEX IF NOT EXISTS study_records_user_id_idx ON study_records(user_id);
CREATE INDEX IF NOT EXISTS study_records_date_idx ON study_records(date);
CREATE INDEX IF NOT EXISTS study_records_user_date_idx ON study_records(user_id, date);

-- 5. 创建用户资料表（可选，用于存储家庭和孩子姓名）
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
  family_name TEXT NOT NULL DEFAULT '我的家庭',
  child_name TEXT NOT NULL DEFAULT '孩子',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own profile" ON user_profiles
  FOR ALL USING (auth.uid() = user_id);

-- 6. 创建更新时间的触发器
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_profiles_updated_at 
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- 7. 创建用户注册后自动创建profile的函数
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (user_id, family_name, child_name)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'family_name', '我的家庭'),
    COALESCE(NEW.raw_user_meta_data->>'child_name', '孩子')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 8. 创建触发器
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

COMMENT ON TABLE study_records IS '学习记录表，存储各科分数和错题数';
COMMENT ON TABLE user_profiles IS '用户资料表，存储家庭和孩子的个性化信息';