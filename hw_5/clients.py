import psycopg2


# 0. Функция, удаляющая структуру БД.
def drop_tables(conn):
    with conn.cursor() as cur:
        cur.execute("""
            DROP TABLE phones;
            DROP TABLE customers;
            """)
    conn.commit()
    print(f'Структура базы данных удалена.')

# 1. Функция, создающая структуру БД.
def create_tables(conn):
    with conn.cursor() as cur:
        cur.execute("""
            CREATE TABLE IF NOT EXISTS customers(
                id SERIAL PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                surname VARCHAR(100) NOT NULL,
                email VARCHAR(100) UNIQUE NOT NULL
            );

            CREATE TABLE IF NOT EXISTS phones(
                id SERIAL PRIMARY KEY,
                number INTEGER NOT NULL,
                customer_id INTEGER REFERENCES customers(id)
            );
            """)
    conn.commit()
    print(f'Структура базы данных создана.')

# 2. Функция, позволяющая добавить нового клиента.
def add_client(conn, first_name, last_name, email):
    with conn.cursor() as cur:
        cur.execute("""
        INSERT INTO customers(name, surname, email) VALUES (%s, %s, %s)
            RETURNING id;
        """, (first_name, last_name, email))
        new_id = cur.fetchone()
    conn.commit()
    print(f'Клиент id {new_id[0]} добавлен в базу.')
    return new_id

# 3. Функция, позволяющая добавить телефон для существующего клиента.
def add_phone(conn, client_id, phone):
    with conn.cursor() as cur:        
        cur.execute("""
        INSERT INTO phones(number, customer_id) VALUES (%s, %s)
        """, (phone, client_id))
        print('Телефон успешно добавлен.')
    conn.commit()
    return

# 4. Функция, позволяющая изменить данные о клиенте.
def change_client(conn, client_id, first_name=None, last_name=None, email=None, phone=None):
    with conn.cursor() as cur:
        if first_name is not None:
            cur.execute("""
            UPDATE customers SET name=%s WHERE id=%s;
            """, (first_name, client_id))
            print('Имя успешно изменено.')
        if last_name is not None:
            cur.execute("""
            UPDATE customers SET surname=%s WHERE id=%s;
            """, (last_name, client_id))
            print('Фамилия успешно изменена.')
        if email is not None:
            cur.execute("""
            UPDATE customers SET email=%s WHERE id=%s;
            """, (email, client_id))
            print('email успешно изменён.')
        if phone is not None:            
            cur.execute("""
            SELECT id, number FROM phones WHERE customer_id=%s;
            """, (client_id,))
            phones_list = cur.fetchall()
            for phone_id, phone_number in phones_list:
                print(f'id {phone_id} - {phone_number}\n')
            phone_ids_list = [elm[0] for elm in phones_list]
            choice = input(f'Какой телефон изменить? Введите номер id из списка: ')
            if choice:
                if int(choice) in phone_ids_list:
                    cur.execute("""
                        UPDATE phones SET number=%s WHERE id=%s;
                        """, (phone, choice))
                    print(f'Телефон успешно изменён.')
                else: print(f'Ошибка! Телефон id {choice} отсутствует у клиента.')
            else: print(f'Ошибка! Телефон не выбран.')            
    conn.commit()

# 5. Функция, позволяющая удалить телефон для существующего клиента.
def delete_phone(conn, client_id):
    with conn.cursor() as cur:
        cur.execute("""
        SELECT id, number FROM phones WHERE customer_id=%s;
        """, (client_id,))
        phones_list = cur.fetchall()
        for phone_id, phone_number in phones_list:
            print(f'id {phone_id} - {phone_number}\n')
        phone_ids_list = [elm[0] for elm in phones_list]
        choice = input(f'Какой телефон удалить? Введите номер id из списка: ')
        if choice:
            if int(choice) in phone_ids_list:
                cur.execute("""
                    DELETE FROM phones WHERE id=%s;
                    """, (choice,))
                print(f'Телефон успешно удалён.')
            else: print(f'Ошибка! Телефон id {choice} отсутствует у клиента.')
        else: print(f'Ошибка! Телефон не выбран.')
    conn.commit()

# 6. Функция, позволяющая удалить существующего клиента.
def delete_client(conn, client_id):
    with conn.cursor() as cur:
        cur.execute("""
        DELETE FROM phones WHERE customer_id=%s;
        """, (client_id,))
        cur.execute("""
        DELETE FROM customers WHERE id=%s;
        """, (client_id,))
        print('Клиент успешно удалён из базы.')
        conn.commit()

# 7. Функция, позволяющая найти клиента по его данным (имени, фамилии, email-у или телефону).
def find_client(conn, first_name=None, last_name=None, email=None, phone=None):
    with conn.cursor() as cur:
        if (first_name is not None) and (last_name is not None) and (email is not None):
            cur.execute("""
                SELECT id FROM customers WHERE (name=%s AND surname=%s AND email=%s);
            """, (first_name, last_name, email))
            requested_id = cur.fetchone()
        if phone is not None:
            cur.execute("""
                SELECT customer_id FROM phones WHERE number=%s;
            """, (phone,))
            requested_id = cur.fetchone()
        return requested_id[0]


if __name__ == '__main__':

    with psycopg2.connect(database='clients', user='postgres', password='postgres') as conn:

        create_tables(conn)
        print()
        add_client(conn, 'Аня', 'Иванова', 'ann_i@mail.ru')
        add_client(conn, 'Ваня', 'Сидоров', 'ivan_s@mail.ru')
        add_client(conn, 'Петя', 'Петров', 'pp@mail.ru')
        print()
        add_phone(conn, '1', '12345')
        add_phone(conn, '2', '45678')
        add_phone(conn, '3', '78945')
        add_phone(conn, '3', '98745')
        print()
        change_client(conn, 1, first_name='Анна')
        change_client(conn, 1, last_name='Сидорова')
        change_client(conn, 1, email='ann_s@mail.ru')
        change_client(conn, 3, phone='65498')
        print()
        delete_phone(conn, 3)
        delete_client(conn, 2)
        print()
        print(f"id Пети: {find_client(conn, first_name='Петя', last_name='Петров', email='pp@mail.ru')}")
        print(f"id владельца телефона 12345: {find_client(conn, phone='12345')}")
        print()
        drop_tables(conn)