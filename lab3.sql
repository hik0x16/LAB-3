-- 1. ВРЕМЕННО СНИМАЕМ ЗАЩИТУ (удаляем внешний ключ)
ALTER TABLE schedule DROP CONSTRAINT fk_schedule_discipline;

-- 2. НАРУШАЕМ ЦЕЛОСТНОСТЬ (добавляем дисциплину с кодом 999, которой нет в базе)
INSERT INTO schedule (group_number, lab_number, discipline_code, day_of_week, lesson_number) 
VALUES ('ТЕСТ-01', '999', 999, 'Суббота', 1);


-- 3. ЛЕВОСТОРОННЕЕ СОЕДИНЕНИЕ (LEFT JOIN)
SELECT 
    d.discipline_code,
    d.name,
    d.description,
    s.group_number,
    s.lab_number,
    s.day_of_week,
    s.lesson_number
FROM disciplines d
LEFT JOIN schedule s ON d.discipline_code = s.discipline_code;


-- 4. ПРАВОСТОРОННЕЕ СОЕДИНЕНИЕ (RIGHT JOIN)
SELECT 
    s.group_number,
    s.lab_number,
    s.day_of_week,
    s.lesson_number,
    s.discipline_code AS schedule_code,
    d.discipline_code,
    d.name
FROM disciplines d
RIGHT JOIN schedule s ON d.discipline_code = s.discipline_code;


-- 5. ВОССТАНАВЛИВАЕМ ЦЕЛОСТНОСТЬ (удаляем битую запись)
DELETE FROM schedule 
WHERE discipline_code = 999;


-- 6. ВКЛЮЧАЕМ ЗАЩИТУ ОБРАТНО (возвращаем внешний ключ на место)
ALTER TABLE schedule ADD CONSTRAINT fk_schedule_discipline 
FOREIGN KEY (discipline_code) REFERENCES disciplines(discipline_code) 
ON DELETE CASCADE ON UPDATE CASCADE;
