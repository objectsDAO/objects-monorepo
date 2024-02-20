module objectsDAO::base64 {
    use std::vector;

    const TABLE: vector<u8> = b"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    public fun encode(str: &vector<u8>): vector<u8> {
        let table = TABLE;
        if (vector::is_empty(str)) {
            return vector::empty<u8>()
        };
        let size = vector::length(str);
        let eq: u8 = 61;
        let res = vector::empty<u8>();

        let m = 0 ;
        while (m < size) {
            vector::push_back(&mut res, *vector::borrow(&table, (((*vector::borrow(str, m) & 0xfc) >> 2) as u64)));
            if (m + 3 >= size) {
                if (size % 3 == 1) {
                    vector::push_back(
                        &mut res,
                        *vector::borrow(&table, (((*vector::borrow(str, m) & 0x03) << 4) as u64))
                    );
                    vector::push_back(&mut res, eq);
                    vector::push_back(&mut res, eq);
                }else if (size % 3 == 2) {
                    vector::push_back(
                        &mut res,
                        *vector::borrow(
                            &table,
                            ((((*vector::borrow(str, m) & 0x03) << 4) + ((*vector::borrow(
                                str,
                                m + 1
                            ) & 0xf0) >> 4)) as u64)
                        )
                    );
                    vector::push_back(
                        &mut res,
                        *vector::borrow(&table, (((*vector::borrow(str, m + 1) & 0x0f) << 2) as u64))
                    );
                    vector::push_back(&mut res, eq);
                }else {
                    vector::push_back(
                        &mut res,
                        *vector::borrow(
                            &table,
                            ((((*vector::borrow(str, m) & 0x03) << 4) + ((*vector::borrow(
                                str,
                                m + 1
                            ) & 0xf0) >> 4)) as u64)
                        )
                    );
                    vector::push_back(
                        &mut res,
                        *vector::borrow(
                            &table,
                            ((((*vector::borrow(str, m + 1) & 0x0f) << 2) + ((*vector::borrow(
                                str,
                                m + 2
                            ) & 0xc0) >> 6)) as u64)
                        )
                    );
                    vector::push_back(&mut res, *vector::borrow(&table, ((*vector::borrow(str, m + 2) & 0x3f) as u64)));
                };
            }else {
                vector::push_back(
                    &mut res,
                    *vector::borrow(
                        &table,
                        ((((*vector::borrow(str, m) & 0x03) << 4) + ((*vector::borrow(str, m + 1) & 0xf0) >> 4)) as u64)
                    )
                );
                vector::push_back(
                    &mut res,
                    *vector::borrow(
                        &table,
                        ((((*vector::borrow(str, m + 1) & 0x0f) << 2) + ((*vector::borrow(
                            str,
                            m + 2
                        ) & 0xc0) >> 6)) as u64)
                    )
                );
                vector::push_back(&mut res, *vector::borrow(&table, ((*vector::borrow(str, m + 2) & 0x3f) as u64)));
            };
            m = m + 3;
        };

        return res
    }

    public fun decode(code: &vector<u8>): vector<u8> {
        if (vector::is_empty(code) || vector::length<u8>(code) % 4 != 0) {
            return vector::empty<u8>()
        };

        let size = vector::length(code);
        let res = vector::empty<u8>();
        let m = 0 ;
        while (m < size) {
            let pos_of_char_1 = pos_of_char(*vector::borrow(code, m + 1));
            vector::push_back(&mut res, (pos_of_char(*vector::borrow(code, m)) << 2) + ((pos_of_char_1 & 0x30) >> 4));
            if ((m + 2 < size) && (*vector::borrow(code, m + 2) != 61) && (*vector::borrow(code, m + 2) != 46)) {
                let pos_of_char_2 = pos_of_char(*vector::borrow(code, m + 2));
                vector::push_back(&mut res, ((pos_of_char_1 & 0x0f) << 4) + ((pos_of_char_2 & 0x3c) >> 2));

                if ((m + 3 < size) && (*vector::borrow(code, m + 3) != 61) && (*vector::borrow(code, m + 3) != 46)) {
                    let pos_of_char_2 = pos_of_char(*vector::borrow(code, m + 2));
                    vector::push_back<u8>(
                        &mut res,
                        ((pos_of_char_2 & 0x03) << 6) + pos_of_char(*vector::borrow(code, m + 3))
                    );
                };
            };

            m = m + 4;
        };

        return res
    }

    fun pos_of_char(char: u8): u8 {
        if (char >= 65 && char <= 90) {
            return char - 65
        }else if (char >= 97 && char <= 122) {
            return char - 97 + (90 - 65) + 1
        }else if (char >= 48 && char <= 57) {
            return char - 48 + (90 - 65) + (122 - 97) + 2
        }else if (char == 43 || char == 45) {
            return 62
        }else if (char == 47 || char == 95) {
            return 63
        };
        abort 1001
    }

    #[test]
    fun test_base64() {
        let str = b"abcdefghijklmnopqrstuvwsyzABCDEFGHIJKLMNOPQRSTUVWSYZ1234567890+/sdfa;fij;woeijfoawejif;oEQJJ'";
        let code = encode(&str);
        let decode_str = decode(&code);
        assert!(
            code == b"YWJjZGVmZ2hpamtsbW5vcHFyc3R1dndzeXpBQkNERUZHSElKS0xNTk9QUVJTVFVWV1NZWjEyMzQ1Njc4OTArL3NkZmE7ZmlqO3dvZWlqZm9hd2VqaWY7b0VRSkon",
            1001
        );
        assert!(str == decode_str, 1002);

        let str = b"123";
        let code = encode(&str);
        let decode_str = decode(&code);
        assert!(code == b"MTIz", 1003);
        assert!(str == decode_str, 1004);

        let str = b"10";
        let code = encode(&str);
        let decode_str = decode(&code);
        assert!(code == b"MTA=", 1005);
        assert!(str == decode_str, 1006);

        let str = b"1";
        let code = encode(&str);
        let decode_str = decode(&code);
        assert!(code == b"MQ==", 1007);
        assert!(str == decode_str, 1008);
    }

    #[test]
    fun test_utf8() {
        use std::debug;
        let str = x"E6B189";
        debug::print(&str);
        debug::print(&encode(&str));
        debug::print(&b"5rGJ");
    }
}
