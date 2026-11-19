// {{{ imports, io, template
// I/O library (`mod lib` below) is from TecTrixer's cp-template:
// https://github.com/TecTrixer/cp-template/blob/main/temp.rs
#![allow(unused_variables, static_mut_refs, unexpected_cfgs)]

#[allow(unused_imports)]
use lib::*;

pub mod lib {
    // {{{ io
    pub use self::io::*;

    pub mod io {
        #![allow(dead_code)]

        use std::{
            collections::*,
            fmt::Display,
            hash::{BuildHasher, Hash},
            io::{BufRead, BufReader, BufWriter, Read, Stdin, Stdout, Write, stdin, stdout},
            ops::Deref,
            str::from_utf8_unchecked,
        };

        pub static mut IO: Option<IoInner<Stdin, Stdout>> = None;

        // --- Read token and byte primitives ---
        pub trait Readable: Sized {
            fn parse_token(token: &[u8]) -> Self;
        }

        macro_rules! impl_unsigned_readable {
            ($($ty:ty),* $(,)?) => {$ (
                impl Readable for $ty {
                    #[inline]
                    fn parse_token(token: &[u8]) -> Self {
                        let mut value: $ty = 0;
                        for &byte in token {
                            value = value.wrapping_mul(10).wrapping_add((byte - b'0') as $ty);
                        }
                        value
                    }
                }
            )* };
        }

        macro_rules! impl_signed_readable {
            ($($ty:ty),* $(,)?) => {$ (
                impl Readable for $ty {
                    #[inline]
                    fn parse_token(token: &[u8]) -> Self {
                        let (negative, digits) = match token.first() {
                            Some(b'-') => (true, &token[1..]),
                            Some(b'+') => (false, &token[1..]),
                            _ => (false, token),
                        };
                        let mut value: $ty = 0;
                        for &byte in digits {
                            value = value.wrapping_mul(10).wrapping_add((byte - b'0') as $ty);
                        }
                        if negative { value.wrapping_neg() } else { value }
                    }
                }
            )* };
        }

        impl_unsigned_readable!(u8, u16, u32, u64, u128, usize);
        impl_signed_readable!(i8, i16, i32, i64, i128, isize);

        impl Readable for String {
            #[inline]
            fn parse_token(token: &[u8]) -> Self {
                unsafe { from_utf8_unchecked(token) }.to_owned()
            }
        }

        impl Readable for char {
            #[inline]
            fn parse_token(token: &[u8]) -> Self {
                std::str::from_utf8(token)
                    .expect("character token is not valid UTF-8")
                    .chars()
                    .next()
                    .expect("empty character token")
            }
        }

        impl Readable for f32 {
            fn parse_token(token: &[u8]) -> Self {
                unsafe { from_utf8_unchecked(token) }.parse().expect("could not parse value")
            }
        }

        impl Readable for f64 {
            fn parse_token(token: &[u8]) -> Self {
                unsafe { from_utf8_unchecked(token) }.parse().expect("could not parse value")
            }
        }

        impl Readable for bool {
            fn parse_token(token: &[u8]) -> Self {
                match token {
                    b"true" | b"1" => true,
                    b"false" | b"0" => false,
                    _ => panic!("could not parse value"),
                }
            }
        }

        pub trait ByteValue: Sized {
            fn from_byte(byte: u8) -> Self;

            fn from_text_bytes(bytes: Vec<u8>) -> Vec<Self> {
                bytes.into_iter().map(Self::from_byte).collect()
            }
        }

        macro_rules! impl_byte_value_cast {
            ($($ty:ty),* $(,)?) => {$ (
                impl ByteValue for $ty {
                    #[inline]
                    fn from_byte(byte: u8) -> Self {
                        byte as $ty
                    }
                }
            )* };
        }

        impl_byte_value_cast!(u8, u16, i8, i16);

        macro_rules! impl_byte_value_unicode_int {
            ($($ty:ty),* $(,)?) => {$ (
                impl ByteValue for $ty {
                    #[inline]
                    fn from_byte(byte: u8) -> Self {
                        byte as $ty
                    }

                    fn from_text_bytes(bytes: Vec<u8>) -> Vec<Self> {
                        decode_utf8_chars(bytes).into_iter().map(|ch| ch as $ty).collect()
                    }
                }
            )* };
        }

        impl_byte_value_unicode_int!(u32, u64, u128, usize, i32, i64, i128, isize);

        impl ByteValue for bool {
            fn from_byte(byte: u8) -> Self {
                match byte {
                    b'0' => false,
                    b'1' => true,
                    _ => panic!("boolean character must be '0' or '1'"),
                }
            }
        }

        impl ByteValue for char {
            #[inline]
            fn from_byte(byte: u8) -> Self {
                byte as char
            }

            fn from_text_bytes(bytes: Vec<u8>) -> Vec<Self> {
                decode_utf8_chars(bytes)
            }
        }

        fn decode_utf8_chars(bytes: Vec<u8>) -> Vec<char> {
            String::from_utf8(bytes)
                .unwrap_or_else(|error| panic!("input is not valid UTF-8: {error}"))
                .chars()
                .collect()
        }

        pub trait ByteCollection: Sized + FromIterator<Self::Item> {
            type Item: ByteValue;
            const HASH_READABLE: bool = true;

            fn from_bytes(bytes: Vec<u8>) -> Self {
                <Self::Item as ByteValue>::from_text_bytes(bytes).into_iter().collect()
            }
        }

        impl<T: ByteValue> ByteCollection for Vec<T> {
            type Item = T;
        }

        impl<T: ByteValue> ByteCollection for VecDeque<T> {
            type Item = T;
        }

        impl<T: ByteValue> ByteCollection for LinkedList<T> {
            type Item = T;
        }

        impl<T: ByteValue + Ord> ByteCollection for BTreeSet<T> {
            type Item = T;
        }

        impl<T: ByteValue + Ord> ByteCollection for BinaryHeap<T> {
            type Item = T;
        }

        impl<T: ByteValue + Eq + Hash, S: BuildHasher + Default> ByteCollection for HashSet<T, S> {
            type Item = T;
        }

        impl ByteCollection for String {
            type Item = char;
            const HASH_READABLE: bool = false;
        }

        pub trait ReadHashRoot {}

        impl<T: ByteValue> ReadHashRoot for Vec<T> {}
        impl<T: ByteValue> ReadHashRoot for VecDeque<T> {}
        impl<T: ByteValue> ReadHashRoot for LinkedList<T> {}
        impl<T: ByteValue + Ord> ReadHashRoot for BinaryHeap<T> {}
        impl<T: ByteValue + Ord> ReadHashRoot for BTreeSet<T> {}
        impl<T: ByteValue + Eq + Hash, S: BuildHasher + Default> ReadHashRoot for HashSet<T, S> {}
        impl<T: ByteValue, const N: usize> ReadHashRoot for [T; N] {}

        #[derive(Clone, Copy, Debug, PartialEq, Eq)]
        enum BoundaryUnit {
            Word,
            Line,
            Paragraph,
            Rest,
        }

        #[derive(Clone, Copy, Debug)]
        pub struct ReadDirective {
            count: usize,
            dynamic_count: bool,
            boundary: BoundaryUnit,
            hash: bool,
        }

        impl ReadDirective {
            fn from_parts(count: usize, dynamic_count: bool, markers: &str) -> Self {
                let dollars = markers.chars().filter(|&ch| ch == '$').count();
                Self {
                    count,
                    dynamic_count,
                    boundary: match dollars {
                        0 => BoundaryUnit::Word,
                        1 => BoundaryUnit::Line,
                        2 => BoundaryUnit::Paragraph,
                        3 => BoundaryUnit::Rest,
                        _ => unreachable!(),
                    },
                    hash: markers.contains('#'),
                }
            }

            fn words(count: usize) -> Self {
                Self::from_parts(count, false, "")
            }

            pub const fn markers_valid(markers: &str, explicit_count: bool) -> bool {
                let bytes = markers.as_bytes();
                let mut dollars = 0;
                let mut hashes = 0;
                let mut index = 0;
                while index < bytes.len() {
                    match bytes[index] {
                        b'$' => dollars += 1,
                        b'#' => hashes += 1,
                        b' ' | b'\t' | b'\n' | b'\r' => {}
                        _ => return false,
                    }
                    index += 1;
                }
                dollars <= 3 && hashes <= 1 && !(dollars == 3 && explicit_count) && !(dollars == 3 && hashes != 0)
            }

            pub fn parse(count: usize, markers: &str) -> Self {
                if markers.chars().filter(|&ch| ch == '$').count() == 3 {
                    panic!("'$$$' cannot have an explicit count");
                }
                assert!(Self::markers_valid(markers, true), "invalid r! annotation or explicit count");
                Self::from_parts(count, false, markers)
            }

            pub fn parse_dynamic(markers: &str) -> Self {
                assert!(Self::markers_valid(markers, true), "invalid r! annotation or dynamic count");
                Self::from_parts(0, true, markers)
            }

            pub fn parse_default(markers: &str) -> Self {
                assert!(Self::markers_valid(markers, false), "invalid r! annotation");
                let count = if markers.chars().filter(|&ch| ch == '$').count() == 3 { <usize>::MAX } else { 1 };
                Self::from_parts(count, false, markers)
            }
        }

        // Buffer size for stdin/stdout (the std default of 8 KiB means many more syscalls).
        const BUF: usize = 1 << 16;

        // Token separators: space, \n, \r, \t (any byte <= b' ') and ','.
        #[inline(always)]
        fn is_skip_char(&b: &u8) -> bool {
            b <= b' ' || b == b','
        }

        pub struct IoInner<R, W>
        where
            R: Read,
            W: Write,
        {
            input: BufReader<R>,
            output: BufWriter<W>,
            scratch: Vec<u8>,
        }

        struct AnnotatedCursor {
            bytes: Vec<u8>,
            pos: usize,
        }

        pub trait AnnotatedSource {
            fn take_region(&mut self, directive: ReadDirective) -> Vec<u8>;
            fn take_token(&mut self) -> Option<Vec<u8>>;
            fn has_token(&mut self) -> bool;

            fn take_count_token(&mut self) -> Option<Vec<u8>>;

            fn resolve_directive(&mut self, mut directive: ReadDirective) -> ReadDirective {
                if directive.dynamic_count {
                    let token = self.take_count_token().expect("missing dynamic r! length");
                    let mut count = 0usize;
                    for byte in token {
                        assert!(byte.is_ascii_digit(), "dynamic r! length must be an unsigned integer");
                        count = count
                            .checked_mul(10)
                            .and_then(|n| n.checked_add(usize::from(byte - b'0')))
                            .expect("dynamic r! length does not fit usize");
                    }
                    directive.count = count;
                    directive.dynamic_count = false;
                }
                directive
            }
        }

        fn validate_rest_parent(directive: ReadDirective, plan: &[ReadDirective], depth: usize) {
            if plan.get(depth + 1).is_some_and(|child| child.boundary == BoundaryUnit::Rest) {
                assert!(
                    directive.count == 1 || directive.boundary == BoundaryUnit::Rest,
                    "'$$$' child requires a parent length of one or '$$$'"
                );
            }
        }

        impl AnnotatedCursor {
            fn new(bytes: Vec<u8>) -> Self {
                Self { bytes, pos: 0 }
            }

            fn skip_separators(&mut self) {
                while self.bytes.get(self.pos).is_some_and(is_skip_char) {
                    self.pos += 1;
                }
            }

            fn take_token(&mut self) -> Option<Vec<u8>> {
                self.skip_separators();
                let start = self.pos;
                while self.bytes.get(self.pos).is_some_and(|b| !is_skip_char(b)) {
                    self.pos += 1;
                }
                (self.pos > start).then(|| self.bytes[start..self.pos].to_vec())
            }

            fn take_line(&mut self) -> Option<(Vec<u8>, Vec<u8>)> {
                if self.pos >= self.bytes.len() {
                    return None;
                }
                let start = self.pos;
                while self.pos < self.bytes.len() && self.bytes[self.pos] != b'\n' && self.bytes[self.pos] != b'\r' {
                    self.pos += 1;
                }
                let line = self.bytes[start..self.pos].to_vec();
                let ending = if self.bytes.get(self.pos) == Some(&b'\r') {
                    self.pos += 1;
                    if self.bytes.get(self.pos) == Some(&b'\n') {
                        self.pos += 1;
                        b"\r\n".to_vec()
                    } else {
                        vec![b'\r']
                    }
                } else if self.bytes.get(self.pos) == Some(&b'\n') {
                    self.pos += 1;
                    vec![b'\n']
                } else {
                    Vec::new()
                };
                Some((line, ending))
            }

            fn take_region(&mut self, directive: ReadDirective) -> Vec<u8> {
                assert!(!directive.dynamic_count, "unresolved dynamic r! length");
                match directive.boundary {
                    BoundaryUnit::Rest => {
                        let bytes = self.bytes[self.pos..].to_vec();
                        self.pos = self.bytes.len();
                        bytes
                    }
                    BoundaryUnit::Word => {
                        let mut bytes = Vec::new();
                        for index in 0..directive.count {
                            self.skip_separators();
                            let start = self.pos;
                            while self.bytes.get(self.pos).is_some_and(|b| !is_skip_char(b)) {
                                self.pos += 1;
                            }
                            if self.pos == start {
                                break;
                            }
                            bytes.extend_from_slice(&self.bytes[start..self.pos]);
                            if index + 1 < directive.count {
                                let separator_start = self.pos;
                                while self.bytes.get(self.pos).is_some_and(is_skip_char) {
                                    self.pos += 1;
                                }
                                if self.pos < self.bytes.len() {
                                    bytes.extend_from_slice(&self.bytes[separator_start..self.pos]);
                                } else {
                                    break;
                                }
                            }
                        }
                        bytes
                    }
                    BoundaryUnit::Line => {
                        let mut lines = Vec::new();
                        for _ in 0..directive.count {
                            if let Some(line) = self.take_line() {
                                lines.push(line);
                            } else {
                                break;
                            }
                        }
                        let mut bytes = Vec::new();
                        for (i, (line, ending)) in lines.iter().enumerate() {
                            bytes.extend_from_slice(line);
                            if i + 1 < lines.len() {
                                bytes.extend_from_slice(ending);
                            }
                        }
                        bytes
                    }
                    BoundaryUnit::Paragraph => {
                        let mut paragraphs = Vec::new();
                        let mut current = Vec::new();
                        let mut ended_with_blank_separator = false;
                        while paragraphs.len() < directive.count {
                            let Some((line, ending)) = self.take_line() else {
                                if !current.is_empty() {
                                    paragraphs.push(std::mem::take(&mut current));
                                }
                                ended_with_blank_separator = false;
                                break;
                            };
                            if line.is_empty() {
                                if !current.is_empty() {
                                    paragraphs.push(std::mem::take(&mut current));
                                    ended_with_blank_separator = true;
                                }
                            } else {
                                current.extend_from_slice(&line);
                                current.extend_from_slice(&ending);
                                ended_with_blank_separator = false;
                            }
                        }
                        if paragraphs.len() < directive.count && !current.is_empty() {
                            paragraphs.push(current);
                        }
                        let mut bytes = Vec::new();
                        for paragraph in &paragraphs {
                            bytes.extend_from_slice(paragraph);
                        }
                        if !ended_with_blank_separator {
                            if bytes.ends_with(b"\r\n") {
                                bytes.truncate(bytes.len() - 2);
                            } else if bytes.last().is_some_and(|b| *b == b'\r' || *b == b'\n') {
                                bytes.pop();
                            }
                        }
                        bytes
                    }
                }
            }
        }

        impl AnnotatedSource for AnnotatedCursor {
            fn take_region(&mut self, directive: ReadDirective) -> Vec<u8> {
                AnnotatedCursor::take_region(self, directive)
            }

            fn take_token(&mut self) -> Option<Vec<u8>> {
                AnnotatedCursor::take_token(self)
            }

            fn take_count_token(&mut self) -> Option<Vec<u8>> {
                let token = AnnotatedCursor::take_token(self);
                self.skip_separators();
                token
            }

            fn has_token(&mut self) -> bool {
                self.skip_separators();
                self.pos < self.bytes.len()
            }
        }

        // --- Write formatting ---
        pub trait FlatWrite {
            fn write_flat<R: Read, W: Write>(&self, io: &mut IoInner<R, W>, first: &mut bool);
        }

        // Text-style output for `w!(# value)`: byte sequences become UTF-8 text,
        // while nested sequences print each text row separated by spaces.
        pub trait TextWrite {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>);
        }

        fn write_flat_atom<T: Display + ?Sized, R: Read, W: Write>(
            value: &T,
            io: &mut IoInner<R, W>,
            first: &mut bool,
        ) {
            if *first {
                *first = false;
            } else {
                io.sp();
            }
            io.w(value);
        }

        fn write_text_atom<T: Display + ?Sized, R: Read, W: Write>(
            value: &T,
            io: &mut IoInner<R, W>,
            first: &mut bool,
        ) {
            write_flat_atom(value, io, first);
        }

        fn write_text_bytes<R: Read, W: Write>(bytes: &[u8], io: &mut IoInner<R, W>, first: &mut bool) {
            write_text_atom(String::from_utf8_lossy(bytes).as_ref(), io, first);
        }

        fn write_text_chars<R: Read, W: Write, I: IntoIterator<Item = char>>(
            chars: I,
            io: &mut IoInner<R, W>,
            first: &mut bool,
        ) {
            let mut chars = chars.into_iter();
            if let Some(ch) = chars.next() {
                if *first {
                    *first = false;
                } else {
                    io.sp();
                }
                io.w(ch);
                for ch in chars {
                    io.w(ch);
                }
            }
        }

        fn write_text_bools<R: Read, W: Write, I: IntoIterator<Item = bool>>(
            values: I,
            io: &mut IoInner<R, W>,
            first: &mut bool,
        ) {
            let mut values = values.into_iter();
            if let Some(value) = values.next() {
                if *first {
                    *first = false;
                } else {
                    io.sp();
                }
                io.w(if value { '1' } else { '0' });
                for value in values {
                    io.w(if value { '1' } else { '0' });
                }
            }
        }

        impl TextWrite for bool {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                io.w(if *self { '1' } else { '0' });
            }
        }

        impl TextWrite for u8 {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                io.w(*self as char);
            }
        }

        impl TextWrite for char {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                io.w(*self);
            }
        }

        impl TextWrite for str {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                io.w(self);
            }
        }

        impl TextWrite for String {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                io.w(self);
            }
        }

        impl<T: TextWrite + ?Sized> TextWrite for &T {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                (**self).write_text(io);
            }
        }

        impl TextWrite for [u8] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                write_text_bytes(self, io, &mut first);
            }
        }

        impl TextWrite for [char] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                write_text_chars(self.iter().copied(), io, &mut first);
            }
        }

        impl TextWrite for [bool] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                write_text_bools(self.iter().copied(), io, &mut first);
            }
        }

        impl<const N: usize> TextWrite for [u8; N] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                self.as_slice().write_text(io);
            }
        }

        impl<const N: usize> TextWrite for [char; N] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                self.as_slice().write_text(io);
            }
        }

        impl<const N: usize> TextWrite for [bool; N] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                self.as_slice().write_text(io);
            }
        }

        impl TextWrite for Vec<u8> {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                self.as_slice().write_text(io);
            }
        }

        impl TextWrite for Vec<char> {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                self.as_slice().write_text(io);
            }
        }

        impl TextWrite for Vec<bool> {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                self.as_slice().write_text(io);
            }
        }

        macro_rules! impl_text_byte_sequence {
            ($($container:ident),* $(,)?) => {$ (
                impl TextWrite for $container<u8> {
                    fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                        let mut first = true;
                        let bytes: Vec<u8> = self.iter().copied().collect();
                        write_text_bytes(&bytes, io, &mut first);
                    }
                }
            )* };
        }

        impl_text_byte_sequence!(VecDeque, LinkedList, BinaryHeap, BTreeSet, HashSet);

        macro_rules! impl_text_char_sequence {
            ($($container:ident),* $(,)?) => {$ (
                impl TextWrite for $container<char> {
                    fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                        let mut first = true;
                        write_text_chars(self.iter().copied(), io, &mut first);
                    }
                }
            )* };
        }

        impl_text_char_sequence!(VecDeque, LinkedList, BinaryHeap, BTreeSet, HashSet);

        macro_rules! impl_text_bool_sequence {
            ($($container:ident),* $(,)?) => {$ (
                impl TextWrite for $container<bool> {
                    fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                        let mut first = true;
                        write_text_bools(self.iter().copied(), io, &mut first);
                    }
                }
            )* };
        }

        impl_text_bool_sequence!(VecDeque, LinkedList, BinaryHeap, BTreeSet, HashSet);

        macro_rules! impl_text_byte_rows {
            ($($container:ident),* $(,)?) => {$ (
                impl TextWrite for $container<Vec<u8>> {
                    fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                        let mut first = true;
                        for row in self {
                            write_text_bytes(row, io, &mut first);
                        }
                    }
                }
            )* };
        }

        impl_text_byte_rows!(Vec, VecDeque, LinkedList, BinaryHeap, BTreeSet, HashSet);

        macro_rules! impl_text_char_rows {
            ($($container:ident),* $(,)?) => {$ (
                impl TextWrite for $container<Vec<char>> {
                    fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                        let mut first = true;
                        for row in self {
                            write_text_chars(row.iter().copied(), io, &mut first);
                        }
                    }
                }
            )* };
        }

        impl_text_char_rows!(Vec, VecDeque, LinkedList, BinaryHeap, BTreeSet, HashSet);

        macro_rules! impl_text_bool_rows {
            ($($container:ident),* $(,)?) => {$ (
                impl TextWrite for $container<Vec<bool>> {
                    fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                        let mut first = true;
                        for row in self {
                            write_text_bools(row.iter().copied(), io, &mut first);
                        }
                    }
                }
            )* };
        }

        impl_text_bool_rows!(Vec, VecDeque, LinkedList, BinaryHeap, BTreeSet, HashSet);

        impl<const N: usize> TextWrite for [Vec<u8>; N] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                for row in self {
                    write_text_bytes(row, io, &mut first);
                }
            }
        }

        impl<const N: usize> TextWrite for [Vec<char>; N] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                for row in self {
                    write_text_chars(row.iter().copied(), io, &mut first);
                }
            }
        }

        impl<const N: usize> TextWrite for [Vec<bool>; N] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                for row in self {
                    write_text_bools(row.iter().copied(), io, &mut first);
                }
            }
        }

        impl<const M: usize> TextWrite for Vec<[u8; M]> {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                for row in self {
                    write_text_bytes(row, io, &mut first);
                }
            }
        }

        impl<const M: usize> TextWrite for Vec<[char; M]> {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                for row in self {
                    write_text_chars(row.iter().copied(), io, &mut first);
                }
            }
        }

        impl<const M: usize> TextWrite for Vec<[bool; M]> {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                for row in self {
                    write_text_bools(row.iter().copied(), io, &mut first);
                }
            }
        }

        impl<const N: usize, const M: usize> TextWrite for [[u8; M]; N] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                for row in self {
                    write_text_bytes(row, io, &mut first);
                }
            }
        }

        impl<const N: usize, const M: usize> TextWrite for [[char; M]; N] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                for row in self {
                    write_text_chars(row.iter().copied(), io, &mut first);
                }
            }
        }

        impl<const N: usize, const M: usize> TextWrite for [[bool; M]; N] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                for row in self {
                    write_text_bools(row.iter().copied(), io, &mut first);
                }
            }
        }

        impl TextWrite for Vec<String> {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                for row in self {
                    write_text_atom(row, io, &mut first);
                }
            }
        }

        impl<const N: usize> TextWrite for [String; N] {
            fn write_text<R: Read, W: Write>(&self, io: &mut IoInner<R, W>) {
                let mut first = true;
                for row in self {
                    write_text_atom(row, io, &mut first);
                }
            }
        }

        pub fn debug_text<T: TextWrite + ?Sized>(value: &T) -> String {
            let mut io = IoInner {
                input: BufReader::new(std::io::empty()),
                output: BufWriter::new(Vec::new()),
                scratch: Vec::new(),
            };
            value.write_text(&mut io);
            let bytes = io.output.into_inner().unwrap();
            String::from_utf8_lossy(&bytes).into_owned()
        }

        pub fn flush_output() {
            unsafe { IO.as_mut().unwrap_unchecked().flush() };
        }

        macro_rules! impl_flat_write_atom {
            ($($ty:ty),* $(,)?) => {$ (
                impl FlatWrite for $ty {
                    #[inline]
                    fn write_flat<R: Read, W: Write>(
                        &self,
                        io: &mut IoInner<R, W>,
                        first: &mut bool,
                    ) {
                        write_flat_atom(self, io, first);
                    }
                }
            )* };
        }

        impl_flat_write_atom!(
            u8, u16, u32, u64, u128, usize, i8, i16, i32, i64, i128, isize, f32, f64, String, str, char, bool,
        );

        impl<T: FlatWrite + ?Sized> FlatWrite for &T {
            #[inline]
            fn write_flat<R: Read, W: Write>(&self, io: &mut IoInner<R, W>, first: &mut bool) {
                (**self).write_flat(io, first);
            }
        }

        impl<T: FlatWrite + ?Sized> FlatWrite for &mut T {
            #[inline]
            fn write_flat<R: Read, W: Write>(&self, io: &mut IoInner<R, W>, first: &mut bool) {
                (**self).write_flat(io, first);
            }
        }

        impl<T: FlatWrite> FlatWrite for [T] {
            fn write_flat<R: Read, W: Write>(&self, io: &mut IoInner<R, W>, first: &mut bool) {
                for item in self {
                    item.write_flat(io, first);
                }
            }
        }

        impl<T: FlatWrite, const N: usize> FlatWrite for [T; N] {
            fn write_flat<R: Read, W: Write>(&self, io: &mut IoInner<R, W>, first: &mut bool) {
                self.as_slice().write_flat(io, first);
            }
        }

        macro_rules! impl_flat_write_sequence {
            ($($container:ident),* $(,)?) => {$ (
                impl<T: FlatWrite> FlatWrite for $container<T> {
                    fn write_flat<R: Read, W: Write>(
                        &self,
                        io: &mut IoInner<R, W>,
                        first: &mut bool,
                    ) {
                        for item in self {
                            item.write_flat(io, first);
                        }
                    }
                }
            )* };
        }

        impl_flat_write_sequence!(Vec, VecDeque, LinkedList);

        impl<T: FlatWrite + Ord> FlatWrite for BinaryHeap<T> {
            fn write_flat<R: Read, W: Write>(&self, io: &mut IoInner<R, W>, first: &mut bool) {
                for item in self {
                    item.write_flat(io, first);
                }
            }
        }

        impl<T: FlatWrite + Eq + Hash, S: BuildHasher> FlatWrite for HashSet<T, S> {
            fn write_flat<R: Read, W: Write>(&self, io: &mut IoInner<R, W>, first: &mut bool) {
                for item in self {
                    item.write_flat(io, first);
                }
            }
        }

        impl<T: FlatWrite + Ord> FlatWrite for BTreeSet<T> {
            fn write_flat<R: Read, W: Write>(&self, io: &mut IoInner<R, W>, first: &mut bool) {
                for item in self {
                    item.write_flat(io, first);
                }
            }
        }

        impl<K: FlatWrite + Eq + Hash, V: FlatWrite, S: BuildHasher> FlatWrite for HashMap<K, V, S> {
            fn write_flat<R: Read, W: Write>(&self, io: &mut IoInner<R, W>, first: &mut bool) {
                for (key, value) in self {
                    key.write_flat(io, first);
                    value.write_flat(io, first);
                }
            }
        }

        impl<K: FlatWrite + Ord, V: FlatWrite> FlatWrite for BTreeMap<K, V> {
            fn write_flat<R: Read, W: Write>(&self, io: &mut IoInner<R, W>, first: &mut bool) {
                for (key, value) in self {
                    key.write_flat(io, first);
                    value.write_flat(io, first);
                }
            }
        }

        macro_rules! impl_flat_write_tuple {
            ($($name:ident),+ $(,)?) => {
                impl<$($name: FlatWrite),+> FlatWrite for ($($name,)+) {
                    #[allow(non_snake_case)]
                    fn write_flat<R: Read, W: Write>(
                        &self,
                        io: &mut IoInner<R, W>,
                        first: &mut bool,
                    ) {
                        let ($($name,)+) = self;
                        $($name.write_flat(io, first);)+
                    }
                }
            };
        }

        impl_flat_write_tuple!(A);
        impl_flat_write_tuple!(A, B);
        impl_flat_write_tuple!(A, B, C);
        impl_flat_write_tuple!(A, B, C, D);
        impl_flat_write_tuple!(A, B, C, D, E);
        impl_flat_write_tuple!(A, B, C, D, E, F);
        impl_flat_write_tuple!(A, B, C, D, E, F, G);
        impl_flat_write_tuple!(A, B, C, D, E, F, G, H);
        impl_flat_write_tuple!(A, B, C, D, E, F, G, H, I);
        impl_flat_write_tuple!(A, B, C, D, E, F, G, H, I, J);
        impl_flat_write_tuple!(A, B, C, D, E, F, G, H, I, J, K);
        impl_flat_write_tuple!(A, B, C, D, E, F, G, H, I, J, K, L);

        // --- Shaped reads for `r!` and `rc!` ---
        pub struct Io;

        pub trait ReadShape: Sized {
            fn rank() -> usize;
            fn read_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[isize]) -> Self;

            fn from_byte(_byte: u8) -> Option<Self> {
                None
            }

            fn from_text_bytes(bytes: Vec<u8>) -> Vec<Self> {
                bytes
                    .into_iter()
                    .map(|byte| {
                        Self::from_byte(byte)
                            .unwrap_or_else(|| panic!("text markers require a byte-convertible collection"))
                    })
                    .collect()
            }
        }

        macro_rules! impl_read_shape_leaf {
            ($($ty:ty),* $(,)?) => {$(
                impl ReadShape for $ty {
                    #[inline(always)]
                    fn rank() -> usize {
                        0
                    }

                    #[inline]
                    fn read_shape<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        _dims: &[isize],
                    ) -> Self {
                        io.read_token::<$ty>()
                    }
                }
            )*};
        }

        impl_read_shape_leaf!(String);

        impl ReadShape for bool {
            #[inline(always)]
            fn rank() -> usize {
                0
            }

            #[inline]
            fn read_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, _dims: &[isize]) -> Self {
                io.read_token::<bool>()
            }

            #[inline]
            fn from_byte(byte: u8) -> Option<Self> {
                match byte {
                    b'1' => Some(true),
                    b'0' => Some(false),
                    _ => panic!("boolean character must be '0' or '1'"),
                }
            }
        }

        macro_rules! impl_read_shape_byte_leaf {
            ($($ty:ty),* $(,)?) => {$ (
                impl ReadShape for $ty {
                    #[inline(always)]
                    fn rank() -> usize {
                        0
                    }

                    #[inline]
                    fn read_shape<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        _dims: &[isize],
                    ) -> Self {
                        io.read_token::<$ty>()
                    }

                    #[inline]
                    fn from_byte(byte: u8) -> Option<Self> {
                        Some(byte as $ty)
                    }
                }
            )* };
        }

        impl_read_shape_byte_leaf!(u8, u16, u32, u64, u128, usize, i8, i16, i32, i64, i128, isize, f32, f64,);

        impl ReadShape for char {
            #[inline(always)]
            fn rank() -> usize {
                0
            }

            #[inline]
            fn read_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, _dims: &[isize]) -> Self {
                io.read_token::<char>()
            }

            #[inline]
            fn from_byte(byte: u8) -> Option<Self> {
                Some(byte as char)
            }

            fn from_text_bytes(bytes: Vec<u8>) -> Vec<Self> {
                decode_utf8_chars(bytes)
            }
        }

        fn read_collection_shape<C, T, R, W>(io: &mut IoInner<R, W>, dims: &[isize]) -> C
        where
            C: FromIterator<T>,
            T: ReadShape,
            R: Read,
            W: Write,
        {
            let n = dims[0];
            match n {
                -1 | -2 => {
                    let bytes = if n == -1 { io.read_word::<Vec<u8>>() } else { io.read_line::<Vec<u8>>() };
                    T::from_text_bytes(bytes).into_iter().collect()
                }
                n if n >= 0 => {
                    let inner = &dims[1..];
                    (0..n as usize).map(|_| T::read_shape(io, inner)).collect()
                }
                _ => panic!("invalid read dimension: {n}"),
            }
        }

        macro_rules! impl_read_shape_seq {
            ($($container:ident),* $(,)?) => {$(
                impl<T: ReadShape> ReadShape for $container<T> {
                    #[inline]
                    fn rank() -> usize {
                        1 + T::rank()
                    }

                    fn read_shape<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        dims: &[isize],
                    ) -> Self {
                        read_collection_shape::<Self, T, _, _>(io, dims)
                    }
                }
            )*};
        }

        impl_read_shape_seq!(Vec, VecDeque, LinkedList);

        impl<T: ReadShape + Ord> ReadShape for BinaryHeap<T> {
            #[inline]
            fn rank() -> usize {
                1 + T::rank()
            }

            fn read_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[isize]) -> Self {
                read_collection_shape::<Self, T, _, _>(io, dims)
            }
        }

        impl<T: ReadShape + Eq + Hash, S: BuildHasher + Default> ReadShape for HashSet<T, S> {
            #[inline]
            fn rank() -> usize {
                1 + T::rank()
            }

            fn read_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[isize]) -> Self {
                read_collection_shape::<Self, T, _, _>(io, dims)
            }
        }

        impl<T: ReadShape + Ord> ReadShape for BTreeSet<T> {
            #[inline]
            fn rank() -> usize {
                1 + T::rank()
            }

            fn read_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[isize]) -> Self {
                read_collection_shape::<Self, T, _, _>(io, dims)
            }
        }

        impl<K: ReadShape + Eq + Hash, V: ReadShape, S: BuildHasher + Default> ReadShape for HashMap<K, V, S> {
            #[inline]
            fn rank() -> usize {
                1 + V::rank()
            }

            fn read_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[isize]) -> Self {
                assert_eq!(K::rank(), 0, "map keys must be scalar-shaped");
                let n = dims[0];
                let inner = &dims[1..];
                assert!(n >= 0, "map dimension must be nonnegative");
                (0..n as usize).map(|_| (K::read_shape(io, &[]), V::read_shape(io, inner))).collect()
            }
        }

        impl<K: ReadShape + Ord, V: ReadShape> ReadShape for BTreeMap<K, V> {
            #[inline]
            fn rank() -> usize {
                1 + V::rank()
            }

            fn read_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[isize]) -> Self {
                assert_eq!(K::rank(), 0, "map keys must be scalar-shaped");
                let n = dims[0];
                let inner = &dims[1..];
                assert!(n >= 0, "map dimension must be nonnegative");
                (0..n as usize).map(|_| (K::read_shape(io, &[]), V::read_shape(io, inner))).collect()
            }
        }

        macro_rules! impl_read_shape_tuple {
            ($($name:ident),+ $(,)?) => {
                impl<$($name: ReadShape),+> ReadShape for ($($name,)+) {
                    #[inline]
                    fn rank() -> usize {
                        0 $(+ $name::rank())+
                    }

                    #[allow(non_snake_case, unused_mut, unused_assignments)]
                    fn read_shape<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        dims: &[isize],
                    ) -> Self {
                        let mut offset = 0;
                        ($({
                            let rank = $name::rank();
                            let value = $name::read_shape(io, &dims[offset..offset + rank]);
                            offset += rank;
                            value
                        },)+)
                    }
                }
            };
        }

        impl_read_shape_tuple!(A);
        impl_read_shape_tuple!(A, B);
        impl_read_shape_tuple!(A, B, C);
        impl_read_shape_tuple!(A, B, C, D);
        impl_read_shape_tuple!(A, B, C, D, E);
        impl_read_shape_tuple!(A, B, C, D, E, F);
        impl_read_shape_tuple!(A, B, C, D, E, F, G);
        impl_read_shape_tuple!(A, B, C, D, E, F, G, H);
        impl_read_shape_tuple!(A, B, C, D, E, F, G, H, I);
        impl_read_shape_tuple!(A, B, C, D, E, F, G, H, I, J);
        impl_read_shape_tuple!(A, B, C, D, E, F, G, H, I, J, K);
        impl_read_shape_tuple!(A, B, C, D, E, F, G, H, I, J, K, L);

        // Fixed-size arrays consume no dimension of their own; each element gets the same `dims`.
        impl<T: ReadShape, const N: usize> ReadShape for [T; N] {
            #[inline]
            fn rank() -> usize {
                T::rank()
            }

            fn read_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[isize]) -> Self {
                std::array::from_fn(|_| T::read_shape(io, dims))
            }
        }

        // --- Lazy iterator reads for `ri!` ---
        pub struct ReadIter<T> {
            remaining: usize,
            dims: Vec<isize>,
            _marker: std::marker::PhantomData<fn() -> T>,
        }

        impl<T: ReadShape> ReadIter<T> {
            pub fn new(count: usize, dims: &[isize]) -> Self {
                assert_eq!(dims.len(), T::rank(), "ri item dimension count mismatch");
                Self { remaining: count, dims: dims.to_vec(), _marker: std::marker::PhantomData }
            }
        }

        impl<T: ReadShape> Iterator for ReadIter<T> {
            type Item = T;

            #[inline]
            fn next(&mut self) -> Option<T> {
                if self.remaining == 0 {
                    return None;
                }
                self.remaining -= 1;
                let io = unsafe { IO.as_mut().unwrap_unchecked() };
                Some(T::read_shape(io, &self.dims))
            }

            #[inline]
            fn size_hint(&self) -> (usize, Option<usize>) {
                (self.remaining, Some(self.remaining))
            }
        }

        impl<T: ReadShape> ExactSizeIterator for ReadIter<T> {}

        pub trait ReadAnnotated: Sized {
            fn rank() -> usize;
            const HASH_ITEM: bool = false;

            fn validate_plan(plan: &[ReadDirective], depth: usize) {
                assert!(
                    !plan.get(depth).is_some_and(|directive| directive.hash),
                    "'#' is invalid for this output shape"
                );
            }

            fn read_annotated<S: AnnotatedSource>(source: &mut S, plan: &[ReadDirective], depth: usize) -> Self;

            fn from_hash_bytes(_bytes: Vec<u8>) -> Vec<Self> {
                panic!("'#' requires a byte/character/integer/bool collection leaf")
            }
        }

        macro_rules! impl_annotated_leaf {
            ($($ty:ty),* $(,)?) => {$ (
                impl ReadAnnotated for $ty {
                    fn rank() -> usize { 0 }

                    fn read_annotated<S: AnnotatedSource>(source: &mut S, plan: &[ReadDirective], depth: usize) -> Self {
                        assert!(!plan.get(depth).is_some_and(|spec| spec.hash), "'#' is invalid for this leaf type");
                        let token = source.take_token().expect("unexpected EOF");
                        <$ty as Readable>::parse_token(&token)
                    }
                }
            )* };
        }

        impl_annotated_leaf!(f32, f64, String);

        impl ReadAnnotated for char {
            fn rank() -> usize {
                0
            }

            const HASH_ITEM: bool = true;

            fn read_annotated<S: AnnotatedSource>(source: &mut S, plan: &[ReadDirective], depth: usize) -> Self {
                assert!(!plan.get(depth).is_some_and(|spec| spec.hash), "'#' is invalid for a scalar char");
                let token = source.take_token().expect("unexpected EOF");
                <char as Readable>::parse_token(&token)
            }

            fn from_hash_bytes(bytes: Vec<u8>) -> Vec<Self> {
                decode_utf8_chars(bytes)
            }
        }

        macro_rules! impl_annotated_byte_hash {
            ($($ty:ty),* $(,)?) => {$ (
                impl ReadAnnotated for $ty {
                    fn rank() -> usize { 0 }

                    const HASH_ITEM: bool = true;

                    fn read_annotated<S: AnnotatedSource>(source: &mut S, plan: &[ReadDirective], depth: usize) -> Self {
                        assert!(!plan.get(depth).is_some_and(|spec| spec.hash), "'#' is invalid for this scalar type");
                        let token = source.take_token().expect("unexpected EOF");
                        <$ty as Readable>::parse_token(&token)
                    }

                    fn from_hash_bytes(bytes: Vec<u8>) -> Vec<Self> {
                        <$ty as ByteValue>::from_text_bytes(bytes)
                    }
                }
            )* };
        }

        impl_annotated_byte_hash!(u8, u16, i8, i16, u32, u64, u128, usize, i32, i64, i128, isize, bool);

        impl<T: ReadAnnotated> ReadAnnotated for Vec<T> {
            fn rank() -> usize {
                1 + T::rank()
            }

            fn validate_plan(plan: &[ReadDirective], depth: usize) {
                if let Some(directive) = plan.get(depth) {
                    if directive.hash {
                        assert!(T::HASH_ITEM, "'#' requires a byte/char/integer/bool collection leaf");
                        assert!(directive.boundary != BoundaryUnit::Rest, "'$$$' cannot be used with '#'");
                    } else if depth + 1 < plan.len() {
                        T::validate_plan(plan, depth + 1);
                    }
                }
            }

            fn read_annotated<S: AnnotatedSource>(source: &mut S, plan: &[ReadDirective], depth: usize) -> Self {
                let directive = source.resolve_directive(plan.get(depth).copied().unwrap_or(ReadDirective::words(1)));
                validate_rest_parent(directive, plan, depth);
                if plan.get(depth + 1).is_some_and(|child| child.boundary == BoundaryUnit::Rest) {
                    return std::iter::once(T::read_annotated(source, plan, depth + 1)).collect();
                }
                assert!(!(directive.hash && directive.boundary == BoundaryUnit::Rest), "'$$$' cannot annotate a leaf");
                let region = source.take_region(directive);
                if directive.hash {
                    assert!(T::HASH_ITEM, "'#' requires a byte/char/integer/bool collection leaf");
                    return T::from_hash_bytes(region).into_iter().collect();
                }
                let mut inner = AnnotatedCursor::new(region);
                let mut result = Vec::new();
                if plan.get(depth + 1).is_some_and(|child| !child.dynamic_count && child.count == 0) {
                    return result;
                }
                while inner.has_token() {
                    let before = inner.pos;
                    result.push(T::read_annotated(&mut inner, plan, depth + 1));
                    assert!(inner.pos > before, "r! child shape made no input progress");
                }
                result
            }
        }

        macro_rules! impl_annotated_sequence {
            ($($container:ident),* $(,)?) => {$ (
                impl<T: ReadAnnotated> ReadAnnotated for $container<T> {
                    fn rank() -> usize { 1 + T::rank() }

                    fn validate_plan(plan: &[ReadDirective], depth: usize) {
                        if let Some(directive) = plan.get(depth) {
                            if directive.hash {
                                assert!(T::HASH_ITEM, "'#' requires a byte/char/integer/bool collection leaf");
                                assert!(directive.boundary != BoundaryUnit::Rest, "'$$$' cannot be used with '#'");
                            } else if depth + 1 < plan.len() {
                                T::validate_plan(plan, depth + 1);
                            }
                        }
                    }

                    fn read_annotated<S: AnnotatedSource>(source: &mut S, plan: &[ReadDirective], depth: usize) -> Self {
                        let directive = source.resolve_directive(plan.get(depth).copied().unwrap_or(ReadDirective::words(1)));
                        validate_rest_parent(directive, plan, depth);
                        if directive.hash {
                            return T::from_hash_bytes(source.take_region(directive)).into_iter().collect();
                        }
                        let region = source.take_region(directive);
                        let mut inner = AnnotatedCursor::new(region);
                        let mut result = Self::new();
                        if plan.get(depth + 1).is_some_and(|child| !child.dynamic_count && child.count == 0) {
                            return result;
                        }
                        while inner.has_token() {
                            let before = inner.pos;
                            result.extend(std::iter::once(T::read_annotated(&mut inner, plan, depth + 1)));
                            assert!(inner.pos > before, "r! child shape made no input progress");
                        }
                        result
                    }
                }
            )* };
        }

        impl_annotated_sequence!(VecDeque, LinkedList);

        impl<T: ReadAnnotated + Ord> ReadAnnotated for BTreeSet<T> {
            fn rank() -> usize {
                1 + T::rank()
            }

            fn read_annotated<S: AnnotatedSource>(source: &mut S, plan: &[ReadDirective], depth: usize) -> Self {
                let directive = source.resolve_directive(plan.get(depth).copied().unwrap_or(ReadDirective::words(1)));
                validate_rest_parent(directive, plan, depth);
                if directive.hash {
                    return T::from_hash_bytes(source.take_region(directive)).into_iter().collect();
                }
                let mut inner = AnnotatedCursor::new(source.take_region(directive));
                let mut result = Self::new();
                if plan.get(depth + 1).is_some_and(|child| !child.dynamic_count && child.count == 0) {
                    return result;
                }
                while inner.has_token() {
                    let before = inner.pos;
                    result.insert(T::read_annotated(&mut inner, plan, depth + 1));
                    assert!(inner.pos > before, "r! child shape made no input progress");
                }
                result
            }
        }

        impl<T: ReadAnnotated + Eq + Hash, S: BuildHasher + Default> ReadAnnotated for HashSet<T, S> {
            fn rank() -> usize {
                1 + T::rank()
            }

            fn validate_plan(plan: &[ReadDirective], depth: usize) {
                if let Some(directive) = plan.get(depth) {
                    if directive.hash {
                        assert!(T::HASH_ITEM, "'#' requires a byte/char/integer/bool collection leaf");
                        assert!(directive.boundary != BoundaryUnit::Rest, "'$$$' cannot be used with '#'");
                    } else if depth + 1 < plan.len() {
                        T::validate_plan(plan, depth + 1);
                    }
                }
            }

            fn read_annotated<SRC: AnnotatedSource>(source: &mut SRC, plan: &[ReadDirective], depth: usize) -> Self {
                let directive = source.resolve_directive(plan.get(depth).copied().unwrap_or(ReadDirective::words(1)));
                validate_rest_parent(directive, plan, depth);
                if directive.hash {
                    return T::from_hash_bytes(source.take_region(directive)).into_iter().collect();
                }
                let mut inner = AnnotatedCursor::new(source.take_region(directive));
                let mut result = Self::default();
                if plan.get(depth + 1).is_some_and(|child| !child.dynamic_count && child.count == 0) {
                    return result;
                }
                while inner.has_token() {
                    let before = inner.pos;
                    result.insert(T::read_annotated(&mut inner, plan, depth + 1));
                    assert!(inner.pos > before, "r! child shape made no input progress");
                }
                result
            }
        }

        impl<T: ReadAnnotated + Ord> ReadAnnotated for BinaryHeap<T> {
            fn rank() -> usize {
                1 + T::rank()
            }

            fn read_annotated<S: AnnotatedSource>(source: &mut S, plan: &[ReadDirective], depth: usize) -> Self {
                let directive = source.resolve_directive(plan.get(depth).copied().unwrap_or(ReadDirective::words(1)));
                validate_rest_parent(directive, plan, depth);
                if directive.hash {
                    return T::from_hash_bytes(source.take_region(directive)).into_iter().collect();
                }
                let mut inner = AnnotatedCursor::new(source.take_region(directive));
                let mut result = Self::new();
                if plan.get(depth + 1).is_some_and(|child| !child.dynamic_count && child.count == 0) {
                    return result;
                }
                while inner.has_token() {
                    let before = inner.pos;
                    result.push(T::read_annotated(&mut inner, plan, depth + 1));
                    assert!(inner.pos > before, "r! child shape made no input progress");
                }
                result
            }
        }

        impl<K: ReadAnnotated + Ord, V: ReadAnnotated> ReadAnnotated for BTreeMap<K, V> {
            fn rank() -> usize {
                1 + std::cmp::max(K::rank(), V::rank())
            }

            fn validate_plan(plan: &[ReadDirective], depth: usize) {
                assert!(!plan.get(depth).is_some_and(|directive| directive.hash), "'#' is not valid for maps");
                if depth + 1 < plan.len() {
                    K::validate_plan(plan, depth + 1);
                    V::validate_plan(plan, depth + 1);
                }
            }

            fn read_annotated<SRC: AnnotatedSource>(source: &mut SRC, plan: &[ReadDirective], depth: usize) -> Self {
                let directive = source.resolve_directive(plan.get(depth).copied().unwrap_or(ReadDirective::words(1)));
                validate_rest_parent(directive, plan, depth);
                assert!(!directive.hash, "'#' is not valid for maps");
                let mut inner = AnnotatedCursor::new(source.take_region(directive));
                let mut result = Self::new();
                if plan.get(depth + 1).is_some_and(|child| !child.dynamic_count && child.count == 0) {
                    return result;
                }
                while inner.has_token() {
                    let before = inner.pos;
                    let key = K::read_annotated(&mut inner, plan, depth + 1);
                    assert!(inner.has_token(), "map input is missing a value");
                    let value = V::read_annotated(&mut inner, plan, depth + 1);
                    result.insert(key, value);
                    assert!(inner.pos > before, "r! map entry made no input progress");
                }
                result
            }
        }

        impl<K: ReadAnnotated + Eq + Hash, V: ReadAnnotated, S: BuildHasher + Default> ReadAnnotated for HashMap<K, V, S> {
            fn rank() -> usize {
                1 + std::cmp::max(K::rank(), V::rank())
            }

            fn validate_plan(plan: &[ReadDirective], depth: usize) {
                assert!(!plan.get(depth).is_some_and(|directive| directive.hash), "'#' is not valid for maps");
                if depth + 1 < plan.len() {
                    K::validate_plan(plan, depth + 1);
                    V::validate_plan(plan, depth + 1);
                }
            }

            fn read_annotated<SRC: AnnotatedSource>(source: &mut SRC, plan: &[ReadDirective], depth: usize) -> Self {
                let directive = source.resolve_directive(plan.get(depth).copied().unwrap_or(ReadDirective::words(1)));
                validate_rest_parent(directive, plan, depth);
                assert!(!directive.hash, "'#' is not valid for maps");
                let mut inner = AnnotatedCursor::new(source.take_region(directive));
                let mut result = Self::default();
                if plan.get(depth + 1).is_some_and(|child| !child.dynamic_count && child.count == 0) {
                    return result;
                }
                while inner.has_token() {
                    let before = inner.pos;
                    let key = K::read_annotated(&mut inner, plan, depth + 1);
                    assert!(inner.has_token(), "map input is missing a value");
                    let value = V::read_annotated(&mut inner, plan, depth + 1);
                    result.insert(key, value);
                    assert!(inner.pos > before, "r! map entry made no input progress");
                }
                result
            }
        }

        macro_rules! impl_annotated_tuple {
            ($($name:ident),+ $(,)?) => {
                impl<$($name: ReadAnnotated),+> ReadAnnotated for ($($name,)+) {
                    fn rank() -> usize {
                        [$( $name::rank(), )+].into_iter().max().unwrap_or(0)
                    }

                    #[allow(non_snake_case)]
                    fn validate_plan(plan: &[ReadDirective], depth: usize) {
                        assert!(
                            !plan.get(depth).is_some_and(|directive| directive.dynamic_count),
                            "dynamic r! lengths require a variable-length container"
                        );
                        if plan.get(depth).is_some_and(|directive| directive.boundary == BoundaryUnit::Rest) {
                            assert_eq!(
                                [$(stringify!($name)),+].len(),
                                1,
                                "'$$$' cannot apply to multiple tuple fields"
                            );
                        }
                        $($name::validate_plan(plan, depth);)+
                    }

                    #[allow(non_snake_case)]
                    fn read_annotated<SRC: AnnotatedSource>(source: &mut SRC, plan: &[ReadDirective], depth: usize) -> Self {
                        ($($name::read_annotated(source, plan, depth),)+)
                    }
                }
            };
        }

        impl_annotated_tuple!(A);
        impl_annotated_tuple!(A, B);
        impl_annotated_tuple!(A, B, C);
        impl_annotated_tuple!(A, B, C, D);
        impl_annotated_tuple!(A, B, C, D, E);
        impl_annotated_tuple!(A, B, C, D, E, F);
        impl_annotated_tuple!(A, B, C, D, E, F, G);
        impl_annotated_tuple!(A, B, C, D, E, F, G, H);
        impl_annotated_tuple!(A, B, C, D, E, F, G, H, I);
        impl_annotated_tuple!(A, B, C, D, E, F, G, H, I, J);
        impl_annotated_tuple!(A, B, C, D, E, F, G, H, I, J, K);
        impl_annotated_tuple!(A, B, C, D, E, F, G, H, I, J, K, L);

        impl<T: ReadAnnotated, const N: usize> ReadAnnotated for [T; N] {
            fn rank() -> usize {
                1 + T::rank()
            }

            fn validate_plan(plan: &[ReadDirective], depth: usize) {
                if let Some(directive) = plan.get(depth) {
                    if directive.boundary == BoundaryUnit::Rest {
                        assert!(N <= 1, "'$$$' cannot apply to multiple array elements");
                    }
                    if directive.hash {
                        assert!(T::HASH_ITEM, "'#' requires a byte/char/integer/bool collection leaf");
                        assert!(directive.boundary != BoundaryUnit::Rest, "'$$$' cannot be used with '#'");
                    } else if depth + 1 < plan.len() {
                        T::validate_plan(plan, depth + 1);
                    }
                }
            }

            fn read_annotated<S: AnnotatedSource>(source: &mut S, plan: &[ReadDirective], depth: usize) -> Self {
                let directive = source.resolve_directive(plan.get(depth).copied().unwrap_or(ReadDirective::words(N)));
                validate_rest_parent(directive, plan, depth);
                if directive.hash {
                    assert!(T::HASH_ITEM, "'#' requires a byte/char/integer/bool collection leaf");
                    let values = T::from_hash_bytes(source.take_region(directive));
                    return values.try_into().unwrap_or_else(|values: Vec<T>| {
                        panic!("'#' produced {} elements, but array requires {N}", values.len())
                    });
                }
                let mut inner = AnnotatedCursor::new(source.take_region(directive));
                (0..N)
                    .map(|_| T::read_annotated(&mut inner, plan, depth + 1))
                    .collect::<Vec<_>>()
                    .try_into()
                    .ok()
                    .expect("not enough input to fill array")
            }
        }

        #[derive(Clone, Copy)]
        pub enum ContinuousDimension {
            Fixed(usize),
            FromInput,
        }

        impl ContinuousDimension {
            fn resolve<R: Read, W: Write>(self, io: &mut IoInner<R, W>) -> usize {
                match self {
                    Self::Fixed(count) => count,
                    Self::FromInput => io.read_dynamic_count(),
                }
            }
        }

        pub trait ReadContinuousShape: Sized {
            const RANK: usize;
            fn read_continuous_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[ContinuousDimension]) -> Self;
        }

        macro_rules! impl_read_continuous_shape_leaf {
            ($($ty:ty),* $(,)?) => {$ (
                impl ReadContinuousShape for $ty {
                    const RANK: usize = 0;

                    fn read_continuous_shape<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        _dims: &[ContinuousDimension],
                    ) -> Self {
                        io.read_byte::<$ty>()
                    }
                }
            )* };
        }

        impl_read_continuous_shape_leaf!(u8, u16, u32, u64, u128, usize, i8, i16, i32, i64, i128, isize,);

        impl ReadContinuousShape for char {
            const RANK: usize = 0;

            fn read_continuous_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, _dims: &[ContinuousDimension]) -> Self {
                io.read_char()
            }
        }

        macro_rules! impl_read_continuous_shape_seq {
            ($($container:ident),* $(,)?) => {$ (
                impl<T: ReadContinuousShape> ReadContinuousShape for $container<T> {
                    const RANK: usize = 1 + T::RANK;

                    fn read_continuous_shape<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        dims: &[ContinuousDimension],
                    ) -> Self {
                        let n = dims[0].resolve(io);
                        let inner = &dims[1..];
                        (0..n).map(|_| T::read_continuous_shape(io, inner)).collect()
                    }
                }
            )* };
        }

        impl_read_continuous_shape_seq!(Vec, VecDeque, LinkedList);

        impl<T: ReadContinuousShape + Ord> ReadContinuousShape for BinaryHeap<T> {
            const RANK: usize = 1 + T::RANK;

            fn read_continuous_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[ContinuousDimension]) -> Self {
                let n = dims[0].resolve(io);
                let inner = &dims[1..];
                (0..n).map(|_| T::read_continuous_shape(io, inner)).collect()
            }
        }

        impl<T: ReadContinuousShape + Eq + Hash, S: BuildHasher + Default> ReadContinuousShape for HashSet<T, S> {
            const RANK: usize = 1 + T::RANK;

            fn read_continuous_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[ContinuousDimension]) -> Self {
                let n = dims[0].resolve(io);
                let inner = &dims[1..];
                (0..n).map(|_| T::read_continuous_shape(io, inner)).collect()
            }
        }

        impl<T: ReadContinuousShape + Ord> ReadContinuousShape for BTreeSet<T> {
            const RANK: usize = 1 + T::RANK;

            fn read_continuous_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[ContinuousDimension]) -> Self {
                let n = dims[0].resolve(io);
                let inner = &dims[1..];
                (0..n).map(|_| T::read_continuous_shape(io, inner)).collect()
            }
        }

        impl<K: ReadContinuousShape + Eq + Hash, V: ReadContinuousShape, S: BuildHasher + Default> ReadContinuousShape
            for HashMap<K, V, S>
        {
            const RANK: usize = 1 + V::RANK;

            fn read_continuous_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[ContinuousDimension]) -> Self {
                assert_eq!(K::RANK, 0, "map keys must be scalar-shaped");
                let n = dims[0].resolve(io);
                let inner = &dims[1..];
                (0..n).map(|_| (K::read_continuous_shape(io, &[]), V::read_continuous_shape(io, inner))).collect()
            }
        }

        impl<K: ReadContinuousShape + Ord, V: ReadContinuousShape> ReadContinuousShape for BTreeMap<K, V> {
            const RANK: usize = 1 + V::RANK;

            fn read_continuous_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[ContinuousDimension]) -> Self {
                assert_eq!(K::RANK, 0, "map keys must be scalar-shaped");
                let n = dims[0].resolve(io);
                let inner = &dims[1..];
                (0..n).map(|_| (K::read_continuous_shape(io, &[]), V::read_continuous_shape(io, inner))).collect()
            }
        }

        macro_rules! impl_read_continuous_shape_tuple {
            ($($name:ident),+ $(,)?) => {
                impl<$($name: ReadContinuousShape),+> ReadContinuousShape for ($($name,)+) {
                    const RANK: usize = 0 $(+ $name::RANK)+;

                    #[allow(non_snake_case, unused_mut, unused_assignments)]
                    fn read_continuous_shape<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        dims: &[ContinuousDimension],
                    ) -> Self {
                        let mut offset = 0;
                        ($({
                            let rank = $name::RANK;
                            let value = $name::read_continuous_shape(io, &dims[offset..offset + rank]);
                            offset += rank;
                            value
                        },)+)
                    }
                }
            };
        }

        impl_read_continuous_shape_tuple!(A);
        impl_read_continuous_shape_tuple!(A, B);
        impl_read_continuous_shape_tuple!(A, B, C);
        impl_read_continuous_shape_tuple!(A, B, C, D);
        impl_read_continuous_shape_tuple!(A, B, C, D, E);
        impl_read_continuous_shape_tuple!(A, B, C, D, E, F);
        impl_read_continuous_shape_tuple!(A, B, C, D, E, F, G);
        impl_read_continuous_shape_tuple!(A, B, C, D, E, F, G, H);
        impl_read_continuous_shape_tuple!(A, B, C, D, E, F, G, H, I);
        impl_read_continuous_shape_tuple!(A, B, C, D, E, F, G, H, I, J);
        impl_read_continuous_shape_tuple!(A, B, C, D, E, F, G, H, I, J, K);
        impl_read_continuous_shape_tuple!(A, B, C, D, E, F, G, H, I, J, K, L);

        #[derive(Clone, Copy)]
        enum TextReadMode {
            Word,
            Line,
        }

        trait ReadTextShape: Sized {
            fn rank() -> usize;
            fn read_text_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[usize], mode: TextReadMode) -> Self;
        }

        trait ReadTextField: Sized {
            fn rank() -> usize;
            fn read_text_field<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[usize], mode: TextReadMode) -> Self;
        }

        impl<T: ReadTextShape> ReadTextField for T {
            fn rank() -> usize {
                T::rank()
            }

            fn read_text_field<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[usize], mode: TextReadMode) -> Self {
                T::read_text_shape(io, dims, mode)
            }
        }

        macro_rules! impl_read_text_leaf {
            ($($ty:ty),* $(,)?) => {$ (
                impl ReadTextShape for $ty {
                    fn rank() -> usize {
                        0
                    }

                    fn read_text_shape<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        _dims: &[usize],
                        mode: TextReadMode,
                    ) -> Self {
                        match mode {
                            TextReadMode::Word => io.read_word::<$ty>(),
                            TextReadMode::Line => io.read_line::<$ty>(),
                        }
                    }
                }
            )* };
        }

        impl_read_text_leaf!(
            Vec<u8>,
            Vec<char>,
            String,
            VecDeque<u8>,
            VecDeque<char>,
            LinkedList<u8>,
            LinkedList<char>,
            BinaryHeap<u8>,
            BinaryHeap<char>,
            BTreeSet<u8>,
            BTreeSet<char>,
            HashSet<u8>,
            HashSet<char>,
        );

        macro_rules! impl_read_text_token_leaf {
            ($($ty:ty),* $(,)?) => {$ (
                impl ReadTextShape for $ty {
                    fn rank() -> usize {
                        0
                    }

                    fn read_text_shape<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        _dims: &[usize],
                        _mode: TextReadMode,
                    ) -> Self {
                        io.read_token::<$ty>()
                    }
                }
            )* };
        }

        impl_read_text_token_leaf!(u16, u32, u64, u128, usize, i8, i16, i32, i64, i128, isize, f32, f64, bool,);

        macro_rules! impl_read_text_token_field {
            ($($ty:ty),* $(,)?) => {$ (
                impl ReadTextField for $ty {
                    fn rank() -> usize {
                        0
                    }

                    fn read_text_field<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        _dims: &[usize],
                        _mode: TextReadMode,
                    ) -> Self {
                        io.read_token::<$ty>()
                    }
                }
            )* };
        }

        impl_read_text_token_field!(u8, char);

        macro_rules! impl_read_text_shape_seq {
            ($($container:ident),* $(,)?) => {$ (
                impl<T: ReadTextShape> ReadTextShape for $container<T> {
                    fn rank() -> usize {
                        1 + T::rank()
                    }

                    fn read_text_shape<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        dims: &[usize],
                        mode: TextReadMode,
                    ) -> Self {
                        let n = dims[0];
                        let inner = &dims[1..];
                        (0..n)
                            .map(|_| T::read_text_shape(io, inner, mode))
                            .collect()
                    }
                }
            )* };
        }

        impl_read_text_shape_seq!(Vec, VecDeque, LinkedList);

        impl<T: ReadTextShape + Ord> ReadTextShape for BinaryHeap<T> {
            fn rank() -> usize {
                1 + T::rank()
            }

            fn read_text_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[usize], mode: TextReadMode) -> Self {
                let n = dims[0];
                let inner = &dims[1..];
                (0..n).map(|_| T::read_text_shape(io, inner, mode)).collect()
            }
        }

        impl<T: ReadTextShape + Eq + Hash, S: BuildHasher + Default> ReadTextShape for HashSet<T, S> {
            fn rank() -> usize {
                1 + T::rank()
            }

            fn read_text_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[usize], mode: TextReadMode) -> Self {
                let n = dims[0];
                let inner = &dims[1..];
                (0..n).map(|_| T::read_text_shape(io, inner, mode)).collect()
            }
        }

        impl<T: ReadTextShape + Ord> ReadTextShape for BTreeSet<T> {
            fn rank() -> usize {
                1 + T::rank()
            }

            fn read_text_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[usize], mode: TextReadMode) -> Self {
                let n = dims[0];
                let inner = &dims[1..];
                (0..n).map(|_| T::read_text_shape(io, inner, mode)).collect()
            }
        }

        impl<K: ReadTextShape + Eq + Hash, V: ReadTextShape, S: BuildHasher + Default> ReadTextShape for HashMap<K, V, S> {
            fn rank() -> usize {
                1 + V::rank()
            }

            fn read_text_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[usize], mode: TextReadMode) -> Self {
                assert_eq!(K::rank(), 0, "map keys must be scalar-shaped");
                let n = dims[0];
                let inner = &dims[1..];
                (0..n).map(|_| (K::read_text_shape(io, &[], mode), V::read_text_shape(io, inner, mode))).collect()
            }
        }

        impl<K: ReadTextShape + Ord, V: ReadTextShape> ReadTextShape for BTreeMap<K, V> {
            fn rank() -> usize {
                1 + V::rank()
            }

            fn read_text_shape<R: Read, W: Write>(io: &mut IoInner<R, W>, dims: &[usize], mode: TextReadMode) -> Self {
                assert_eq!(K::rank(), 0, "map keys must be scalar-shaped");
                let n = dims[0];
                let inner = &dims[1..];
                (0..n).map(|_| (K::read_text_shape(io, &[], mode), V::read_text_shape(io, inner, mode))).collect()
            }
        }

        macro_rules! impl_read_text_shape_tuple {
            ($($name:ident),+ $(,)?) => {
                impl<$($name: ReadTextField),+> ReadTextShape for ($($name,)+) {
                    fn rank() -> usize {
                        0 $(+ $name::rank())+
                    }

                    #[allow(non_snake_case, unused_mut, unused_assignments)]
                    fn read_text_shape<R: Read, W: Write>(
                        io: &mut IoInner<R, W>,
                        dims: &[usize],
                        mode: TextReadMode,
                    ) -> Self {
                        let mut offset = 0;
                        ($({
                            let rank = $name::rank();
                            let value = $name::read_text_field(io, &dims[offset..offset + rank], mode);
                            offset += rank;
                            value
                        },)+)
                    }
                }
            };
        }

        impl_read_text_shape_tuple!(A);
        impl_read_text_shape_tuple!(A, B);
        impl_read_text_shape_tuple!(A, B, C);
        impl_read_text_shape_tuple!(A, B, C, D);
        impl_read_text_shape_tuple!(A, B, C, D, E);
        impl_read_text_shape_tuple!(A, B, C, D, E, F);
        impl_read_text_shape_tuple!(A, B, C, D, E, F, G);
        impl_read_text_shape_tuple!(A, B, C, D, E, F, G, H);
        impl_read_text_shape_tuple!(A, B, C, D, E, F, G, H, I);
        impl_read_text_shape_tuple!(A, B, C, D, E, F, G, H, I, J);
        impl_read_text_shape_tuple!(A, B, C, D, E, F, G, H, I, J, K);
        impl_read_text_shape_tuple!(A, B, C, D, E, F, G, H, I, J, K, L);

        // --- I/O runtime ---
        impl std::ops::DerefMut for Io {
            fn deref_mut(&mut self) -> &mut Self::Target {
                unsafe { IO.as_mut().unwrap_unchecked() }
            }
        }

        impl Deref for Io {
            type Target = IoInner<Stdin, Stdout>;

            fn deref(&self) -> &Self::Target {
                unsafe { IO.as_mut().unwrap_unchecked() }
            }
        }

        impl Io {
            pub fn new() -> Self {
                unsafe {
                    IO = Some(IoInner::new());
                }
                Self
            }
        }

        impl Default for Io {
            fn default() -> Self {
                Self::new()
            }
        }

        impl IoInner<Stdin, Stdout> {
            pub fn new() -> IoInner<Stdin, Stdout> {
                IoInner {
                    input: BufReader::with_capacity(BUF, stdin()),
                    output: BufWriter::with_capacity(BUF, stdout()),
                    scratch: Vec::new(),
                }
            }
        }

        impl Default for IoInner<Stdin, Stdout> {
            fn default() -> Self {
                Self::new()
            }
        }

        impl Drop for Io {
            fn drop(&mut self) {
                self.flush();
            }
        }

        impl<R: Read, W: Write> IoInner<R, W> {
            // Consume separators, optionally stopping after the first line ending.
            #[inline]
            fn skip_separators(&mut self, stop_after_line_ending: bool) {
                loop {
                    let buf = self.input.fill_buf().unwrap();
                    let len = buf.len();
                    if len == 0 {
                        return;
                    }

                    let n = buf.iter().position(|b| !is_skip_char(b)).unwrap_or(len);
                    if stop_after_line_ending && let Some(i) = buf[..n].iter().position(|&b| b == b'\n' || b == b'\r') {
                        let is_cr = buf[i] == b'\r';
                        let is_crlf = buf[i] == b'\r' && buf.get(i + 1) == Some(&b'\n');
                        self.input.consume(i + 1 + usize::from(is_crlf));
                        if is_cr && !is_crlf && self.input.fill_buf().unwrap().first() == Some(&b'\n') {
                            self.input.consume(1);
                        }
                        return;
                    }

                    self.input.consume(n);
                    if n < len {
                        return;
                    }
                }
            }

            // Parses the token straight out of the read buffer (no per-token allocation).
            // Works lazily, so it is still fine for interactive problems.
            pub fn read_token<T: Readable>(&mut self) -> T {
                self.skip_separators(false);
                let buf = self.input.fill_buf().unwrap();
                if buf.is_empty() {
                    panic!("unexpected EOF");
                }
                if let Some(p) = buf.iter().position(is_skip_char) {
                    let v = T::parse_token(&buf[..p]);
                    self.input.consume(p);
                    self.skip_separators(true);
                    return v;
                }
                // Token runs past the end of the buffer: stitch it together in `scratch`.
                self.scratch.clear();
                loop {
                    let buf = self.input.fill_buf().unwrap();
                    if buf.is_empty() {
                        break;
                    }
                    match buf.iter().position(is_skip_char) {
                        Some(p) => {
                            self.scratch.extend_from_slice(&buf[..p]);
                            self.input.consume(p);
                            break;
                        }
                        None => {
                            let l = buf.len();
                            self.scratch.extend_from_slice(buf);
                            self.input.consume(l);
                        }
                    }
                }
                let value = T::parse_token(&self.scratch);
                self.skip_separators(true);
                value
            }

            pub fn read_dynamic_count(&mut self) -> usize {
                self.skip_separators(false);
                let mut count = 0usize;
                let mut read_any = false;
                loop {
                    let buf = self.input.fill_buf().unwrap();
                    if buf.is_empty() {
                        break;
                    }
                    let len = buf.len();
                    let end = buf.iter().position(is_skip_char).unwrap_or(len);
                    for &byte in &buf[..end] {
                        assert!(byte.is_ascii_digit(), "continuous dimension count must be an unsigned integer");
                        count = count
                            .checked_mul(10)
                            .and_then(|n| n.checked_add(usize::from(byte - b'0')))
                            .expect("continuous dimension count does not fit usize");
                    }
                    read_any |= end > 0;
                    self.input.consume(end);
                    if end < len {
                        break;
                    }
                }
                assert!(read_any, "missing continuous dimension count");
                self.skip_separators(true);
                count
            }

            pub fn read_line<C: ByteCollection>(&mut self) -> C {
                let mut res = Vec::new();
                self.input.read_until(b'\n', &mut res).unwrap();
                if res.last() == Some(&b'\n') {
                    res.pop();
                    if res.last() == Some(&b'\r') {
                        res.pop();
                    }
                }
                C::from_bytes(res)
            }

            pub fn read_all<C: ByteCollection>(&mut self) -> C {
                let mut res = Vec::new();
                self.input.read_to_end(&mut res).unwrap();
                C::from_bytes(res)
            }

            fn next_raw_byte(&mut self) -> Option<u8> {
                let byte = self.input.fill_buf().unwrap().first().copied()?;
                self.input.consume(1);
                Some(byte)
            }

            fn next_raw_line(&mut self) -> Option<(Vec<u8>, Vec<u8>)> {
                let mut content = Vec::new();
                loop {
                    match self.next_raw_byte() {
                        Some(b'\n') => return Some((content, vec![b'\n'])),
                        Some(b'\r') => {
                            let ending = if self.input.fill_buf().unwrap().first() == Some(&b'\n') {
                                self.input.consume(1);
                                b"\r\n".to_vec()
                            } else {
                                vec![b'\r']
                            };
                            return Some((content, ending));
                        }
                        Some(byte) => content.push(byte),
                        None if content.is_empty() => return None,
                        None => return Some((content, Vec::new())),
                    }
                }
            }

            fn read_annotated_bytes(&mut self, count: usize, unit: BoundaryUnit) -> Vec<u8> {
                match unit {
                    BoundaryUnit::Rest => {
                        let mut bytes = Vec::new();
                        self.input.read_to_end(&mut bytes).unwrap();
                        bytes
                    }
                    BoundaryUnit::Word => {
                        let mut bytes = Vec::new();
                        for index in 0..count {
                            self.skip_separators(false);
                            let mut word = Vec::new();
                            loop {
                                let buf = self.input.fill_buf().unwrap();
                                if buf.is_empty() {
                                    break;
                                }
                                match buf.iter().position(is_skip_char) {
                                    Some(0) => break,
                                    Some(end) => {
                                        word.extend_from_slice(&buf[..end]);
                                        self.input.consume(end);
                                        break;
                                    }
                                    None => {
                                        let len = buf.len();
                                        word.extend_from_slice(buf);
                                        self.input.consume(len);
                                    }
                                }
                            }
                            if word.is_empty() {
                                break;
                            }
                            bytes.extend_from_slice(&word);
                            if index + 1 < count {
                                let mut separators = Vec::new();
                                loop {
                                    let buf = self.input.fill_buf().unwrap();
                                    if buf.is_empty() || !is_skip_char(&buf[0]) {
                                        break;
                                    }
                                    let n = buf.iter().take_while(|b| is_skip_char(b)).count();
                                    separators.extend_from_slice(&buf[..n]);
                                    self.input.consume(n);
                                }
                                if self.input.fill_buf().unwrap().is_empty() {
                                    break;
                                }
                                bytes.extend_from_slice(&separators);
                            }
                        }
                        bytes
                    }
                    BoundaryUnit::Line => {
                        let mut lines = Vec::<(Vec<u8>, Vec<u8>)>::new();
                        for _ in 0..count {
                            let Some(line) = self.next_raw_line() else { break };
                            lines.push(line);
                        }
                        let mut bytes = Vec::new();
                        for (index, (line, ending)) in lines.iter().enumerate() {
                            bytes.extend_from_slice(line);
                            if index + 1 < lines.len() {
                                bytes.extend_from_slice(ending);
                            }
                        }
                        bytes
                    }
                    BoundaryUnit::Paragraph => {
                        let mut paragraphs = Vec::<Vec<u8>>::new();
                        let mut paragraph = Vec::new();
                        let mut ended_with_blank_separator = false;
                        while paragraphs.len() < count {
                            let Some((line, ending)) = self.next_raw_line() else {
                                if !paragraph.is_empty() {
                                    paragraphs.push(std::mem::take(&mut paragraph));
                                }
                                ended_with_blank_separator = false;
                                break;
                            };
                            if line.is_empty() {
                                if !paragraph.is_empty() {
                                    paragraphs.push(std::mem::take(&mut paragraph));
                                    ended_with_blank_separator = true;
                                }
                            } else {
                                paragraph.extend_from_slice(&line);
                                paragraph.extend_from_slice(&ending);
                                ended_with_blank_separator = false;
                            }
                        }
                        if paragraphs.len() < count && !paragraph.is_empty() {
                            paragraphs.push(paragraph);
                        }
                        let mut bytes = Vec::new();
                        for paragraph in &paragraphs {
                            bytes.extend_from_slice(paragraph);
                        }
                        if !ended_with_blank_separator {
                            if bytes.ends_with(b"\r\n") {
                                bytes.truncate(bytes.len() - 2);
                            } else if bytes.last().is_some_and(|b| *b == b'\r' || *b == b'\n') {
                                bytes.pop();
                            }
                        }
                        bytes
                    }
                }
            }

            pub fn read_annotated<C: ByteCollection>(&mut self, count: usize, markers: &str) -> C {
                let directive = if count == <usize>::MAX && markers.contains("$$$") {
                    ReadDirective::parse_default(markers)
                } else {
                    ReadDirective::parse(count, markers)
                };
                assert!(markers.contains('#'), "annotated leaf reads require '#'");
                assert!(C::HASH_READABLE, "'#' is not valid for this output type");
                assert!(directive.hash, "annotated leaf reads require '#'");
                assert_ne!(directive.boundary, BoundaryUnit::Rest, "'$$$' cannot annotate a leaf");
                let bytes = self.read_annotated_bytes(directive.count, directive.boundary);
                C::from_bytes(bytes)
            }

            pub fn read_plan<C: ReadAnnotated>(&mut self, plan: &[ReadDirective]) -> C {
                assert!(plan.len() <= C::rank(), "r! has more annotation levels than the output shape");
                for (depth, spec) in plan.iter().enumerate() {
                    if spec.boundary == BoundaryUnit::Rest && depth > 0 {
                        let parent = plan[depth - 1];
                        assert!(
                            parent.dynamic_count || parent.count == 1 || parent.boundary == BoundaryUnit::Rest,
                            "'$$$' child requires a parent length of one or '$$$'"
                        );
                    }
                }
                if let Some((rest_depth, _)) =
                    plan.iter().enumerate().rev().find(|(_, directive)| directive.boundary == BoundaryUnit::Rest)
                    && rest_depth + 1 < C::rank()
                {
                    let next_count = plan
                        .get(rest_depth + 1)
                        .map_or(1, |directive| if directive.dynamic_count { 1 } else { directive.count });
                    assert_eq!(
                        next_count, 0,
                        "input-consuming reads cannot follow '$$$'; set the next dimension to zero"
                    );
                }
                C::validate_plan(plan, 0);
                C::read_annotated(self, plan, 0)
            }

            // Reads the next non-separator byte.
            pub fn read_byte<T: ByteValue>(&mut self) -> T {
                self.skip_separators(false);
                let byte = *self.input.fill_buf().unwrap().first().expect("unexpected EOF");
                self.input.consume(1);
                self.skip_separators(true);
                T::from_byte(byte)
            }

            fn read_char(&mut self) -> char {
                self.skip_separators(false);
                let first = *self.input.fill_buf().unwrap().first().expect("unexpected EOF");
                let width = match first {
                    0x00..=0x7f => 1,
                    0xc2..=0xdf => 2,
                    0xe0..=0xef => 3,
                    0xf0..=0xf4 => 4,
                    _ => panic!("input is not valid UTF-8"),
                };
                let mut bytes = [0; 4];
                bytes[0] = first;
                self.input.consume(1);
                for byte in &mut bytes[1..width] {
                    *byte = *self.input.fill_buf().unwrap().first().expect("incomplete UTF-8 character");
                    self.input.consume(1);
                }
                let value =
                    std::str::from_utf8(&bytes[..width]).expect("input is not valid UTF-8").chars().next().unwrap();
                self.skip_separators(true);
                value
            }

            // Reads the next whitespace/comma-delimited token without assuming UTF-8.
            pub fn read_word<C: ByteCollection>(&mut self) -> C {
                self.skip_separators(false);
                let buf = self.input.fill_buf().unwrap();
                if buf.is_empty() {
                    panic!("unexpected EOF");
                }
                if let Some(p) = buf.iter().position(is_skip_char) {
                    let word = buf[..p].to_vec();
                    self.input.consume(p);
                    self.skip_separators(true);
                    return C::from_bytes(word);
                }

                self.scratch.clear();
                loop {
                    let buf = self.input.fill_buf().unwrap();
                    if buf.is_empty() {
                        break;
                    }
                    match buf.iter().position(is_skip_char) {
                        Some(p) => {
                            self.scratch.extend_from_slice(&buf[..p]);
                            self.input.consume(p);
                            break;
                        }
                        None => {
                            let len = buf.len();
                            self.scratch.extend_from_slice(buf);
                            self.input.consume(len);
                        }
                    }
                }
                let word = std::mem::take(&mut self.scratch);
                self.skip_separators(true);
                C::from_bytes(word)
            }

            pub fn r<C: ReadShape>(&mut self, dims: &[isize]) -> C {
                assert_eq!(dims.len(), C::rank(), "r dimension count mismatch");
                C::read_shape(self, dims)
            }

            pub fn read_continuous_shape<C: ReadContinuousShape>(&mut self, dims: &[ContinuousDimension]) -> C {
                assert_eq!(dims.len(), C::RANK, "rc dimension count mismatch");
                C::read_continuous_shape(self, dims)
            }

            pub fn w<T: Display>(&mut self, t: T) {
                unsafe { write!(&mut self.output, "{t}").unwrap_unchecked() };
            }

            pub fn write_flat<T: FlatWrite + ?Sized>(&mut self, value: &T) {
                let mut first = true;
                value.write_flat(self, &mut first);
            }

            pub fn write_text<T: TextWrite + ?Sized>(&mut self, value: &T) {
                value.write_text(self);
            }

            // Write pre-built format arguments directly (used by `wf!`, avoids a String per call).
            pub fn wfmt(&mut self, args: std::fmt::Arguments) {
                unsafe { self.output.write_fmt(args).unwrap_unchecked() };
            }

            // Newline / space as raw bytes instead of going through the formatting machinery.
            #[inline]
            pub fn nl(&mut self) {
                unsafe { self.output.write_all(b"\n").unwrap_unchecked() };
            }

            #[inline]
            pub fn sp(&mut self) {
                unsafe { self.output.write_all(b" ").unwrap_unchecked() };
            }

            fn flush(&mut self) {
                unsafe { self.output.flush().unwrap_unchecked() }
            }
        }

        impl<R: Read, W: Write> AnnotatedSource for IoInner<R, W> {
            fn take_region(&mut self, directive: ReadDirective) -> Vec<u8> {
                assert!(!directive.dynamic_count, "unresolved dynamic r! length");
                self.read_annotated_bytes(directive.count, directive.boundary)
            }

            fn take_token(&mut self) -> Option<Vec<u8>> {
                self.skip_separators(false);
                let mut token = Vec::new();
                loop {
                    let buf = self.input.fill_buf().unwrap();
                    if buf.is_empty() {
                        break;
                    }
                    match buf.iter().position(is_skip_char) {
                        Some(0) => break,
                        Some(end) => {
                            token.extend_from_slice(&buf[..end]);
                            self.input.consume(end);
                            break;
                        }
                        None => {
                            let len = buf.len();
                            token.extend_from_slice(buf);
                            self.input.consume(len);
                        }
                    }
                }
                (!token.is_empty()).then_some(token)
            }

            fn has_token(&mut self) -> bool {
                self.skip_separators(false);
                !self.input.fill_buf().unwrap().is_empty()
            }

            fn take_count_token(&mut self) -> Option<Vec<u8>> {
                let token = self.take_token();
                self.skip_separators(false);
                token
            }
        }

        // --- Public macros; kept after the implementation machinery ---
        #[macro_export]
        macro_rules! r {
            (* $($marker:tt)*) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                let plan = $crate::r!(@plan [] [] * $($marker)*);
                let value = io.read_plan(&plan);
                $crate::r!(@check_first_inferred value; [] * $($marker)*);
                value
            }};
            (@check_marker $ty:ty; [# $($rest:tt)*]) => {{
                fn require_hash_root<T: $crate::lib::io::ReadHashRoot>() {}
                require_hash_root::<$ty>();
            }};
            (@check_marker $ty:ty; [$first:tt $($rest:tt)*]) => {
                $crate::r!(@check_marker $ty; [$($rest)*])
            };
            (@check_marker $ty:ty; []) => {{}};
            (@check_first $ty:ty; [$($current:tt)*] , $($rest:tt)+) => {
                $crate::r!(@check_marker $ty; [$($current)*])
            };
            (@check_first $ty:ty; [$($current:tt)*] $next:tt $($rest:tt)*) => {
                $crate::r!(@check_first $ty; [$($current)* $next] $($rest)*)
            };
            (@check_first $ty:ty; [$($current:tt)+]) => {
                $crate::r!(@check_marker $ty; [$($current)+])
            };
            (@check_marker_inferred $value:ident; [# $($rest:tt)*]) => {{
                fn require_hash_root<T: $crate::lib::io::ReadHashRoot>(_: &T) {}
                require_hash_root(&$value);
            }};
            (@check_marker_inferred $value:ident; [$first:tt $($rest:tt)*]) => {
                $crate::r!(@check_marker_inferred $value; [$($rest)*])
            };
            (@check_marker_inferred $value:ident; []) => {{}};
            (@check_first_inferred $value:ident; [$($current:tt)*] , $($rest:tt)+) => {
                $crate::r!(@check_marker_inferred $value; [$($current)*])
            };
            (@check_first_inferred $value:ident; [$($current:tt)*] $next:tt $($rest:tt)*) => {
                $crate::r!(@check_first_inferred $value; [$($current)* $next] $($rest)*)
            };
            (@check_first_inferred $value:ident; [$($current:tt)+]) => {
                $crate::r!(@check_marker_inferred $value; [$($current)+])
            };
            (@count $count:expr) => {{
                let count: usize = $count;
                count as isize
            }};
            (@explicit $count:expr; [$($marker:tt)*]) => {{
                const _: () = assert!(
                    $crate::lib::io::ReadDirective::markers_valid(stringify!($($marker)*), true),
                    "invalid r! annotation; '$$$' has no explicit count and markers must be valid"
                );
                let count: usize = $count;
                $crate::lib::io::ReadDirective::parse(count, stringify!($($marker)*))
            }};
            (@default [$($marker:tt)+]) => {{
                const _: () = assert!(
                    $crate::lib::io::ReadDirective::markers_valid(stringify!($($marker)+), false),
                    "invalid r! annotation markers"
                );
                $crate::lib::io::ReadDirective::parse_default(stringify!($($marker)+))
            }};
            (@dynamic [$($marker:tt)*]) => {{
                const _: () = assert!(
                    $crate::lib::io::ReadDirective::markers_valid(stringify!($($marker)*), true),
                    "invalid r! annotation or dynamic count"
                );
                $crate::lib::io::ReadDirective::parse_dynamic(stringify!($($marker)*))
            }};
            (@directive [* $($marker:tt)*]) => {
                $crate::r!(@dynamic [$($marker)*])
            };
            (@directive [($count:expr) $($marker:tt)*]) => {
                $crate::r!(@explicit $count; [$($marker)*])
            };
            (@directive [$count:literal $($marker:tt)*]) => {
                $crate::r!(@explicit $count; [$($marker)*])
            };
            (@directive [$count:ident $($marker:tt)+]) => {
                $crate::r!(@explicit $count; [$($marker)+])
            };
            (@directive [#]) => {
                $crate::r!(@default [#])
            };
            (@directive [$count:expr]) => {
                $crate::r!(@explicit $count; [])
            };
            (@directive [$($marker:tt)+]) => {
                $crate::r!(@default [$($marker)+])
            };
            (@plan [$($done:expr,)*] [$($current:tt)+] , $($rest:tt)+) => {
                $crate::r!(@plan [$($done,)* $crate::r!(@directive [$($current)+]),] [] $($rest)+)
            };
            (@plan [$($done:expr,)*] [$($current:tt)*] $next:tt $($rest:tt)*) => {
                $crate::r!(@plan [$($done,)*] [$($current)* $next] $($rest)*)
            };
            (@plan [$($done:expr,)*] [$($current:tt)+]) => {
                [$($done,)* $crate::r!(@directive [$($current)+])]
            };
            ($ty:ty; [$($bracketed:tt)*] $(, [$($more:tt)*])*) => {
                compile_error!("r! dimensions are comma-separated; do not wrap them in square brackets")
            };
            ($ty:ty; #) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                $crate::r!(@check_first $ty; [] #);
                let plan = $crate::r!(@plan [] [] #);
                io.read_plan::<$ty>(&plan)
            }};
            ($ty:ty; * $($marker:tt)*) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                $crate::r!(@check_first $ty; [] * $($marker)*);
                let plan = $crate::r!(@plan [] [] * $($marker)*);
                io.read_plan::<$ty>(&plan)
            }};
            ($ty:ty; $($dim:expr),* $(,)?) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                io.r::<$ty>(&[$($crate::r!(@count $dim)),*])
            }};
            ($ty:ty; $($marker:tt)+) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                $crate::r!(@check_first $ty; [] $($marker)+);
                let plan = $crate::r!(@plan [] [] $($marker)+);
                io.read_plan::<$ty>(&plan)
            }};
            (#) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                let plan = $crate::r!(@plan [] [] #);
                let value = io.read_plan(&plan);
                $crate::r!(@check_first_inferred value; [] #);
                value
            }};
            ($($dim:expr),* $(,)?) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                io.r(&[$($crate::r!(@count $dim)),*])
            }};
            ($($marker:tt)+) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                let plan = $crate::r!(@plan [] [] $($marker)+);
                let value = io.read_plan(&plan);
                $crate::r!(@check_first_inferred value; [] $($marker)+);
                value
            }};
        }

        #[macro_export]
        macro_rules! ri {
            // `*` reads the iteration count from the input
            (* $(, $($rest:tt)*)?) => {{
                let count: usize = $crate::r!();
                (0..count).map(move |_| $crate::r!($($($rest)*)?))
            }};
            ($ty:ty; * $(, $($rest:tt)*)?) => {{
                let count: usize = $crate::r!();
                (0..count).map(move |_| $crate::r!($ty; $($($rest)*)?))
            }};
            ($ty:ty; $count:expr $(, $($rest:tt)*)?) => {{
                let count: usize = $count;
                (0..count).map(move |_| $crate::r!($ty; $($($rest)*)?))
            }};
            ($count:expr $(, $($rest:tt)*)?) => {{
                let count: usize = $count;
                (0..count).map(move |_| $crate::r!($($($rest)*)?))
            }};
        }

        #[macro_export]
        macro_rules! rc {
            (@fixed_dimension $count:expr) => {
                $crate::lib::io::ContinuousDimension::Fixed(
                    <usize>::try_from($count).expect("rc dimension must be nonnegative")
                )
            };
            (@read [$ty:ty]; $($dims:tt)*) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                let dims = $crate::rc!(@dimensions [] [] $($dims)*);
                io.read_continuous_shape::<$ty>(&dims)
            }};
            (@read []; $($dims:tt)*) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                let dims = $crate::rc!(@dimensions [] [] $($dims)*);
                io.read_continuous_shape(&dims)
            }};
            (@dimension [- $count:literal]) => {
                compile_error!("rc dimensions must be nonnegative")
            };
            (@dimension [(- $count:literal)]) => {
                compile_error!("rc dimensions must be nonnegative")
            };
            (@dimension [*]) => {
                $crate::lib::io::ContinuousDimension::FromInput
            };
            (@dimension [($count:expr)]) => {
                $crate::rc!(@fixed_dimension $count)
            };
            (@dimension [$count:literal]) => {
                $crate::rc!(@fixed_dimension $count)
            };
            (@dimension [$count:ident]) => {
                $crate::rc!(@fixed_dimension $count)
            };
            (@dimension [$first:tt $($rest:tt)+]) => {
                compile_error!("compound rc! dimension expressions must be parenthesized")
            };
            (@dimensions [$($done:expr,)*] [$($current:tt)+] , $($rest:tt)+) => {
                $crate::rc!(@dimensions [$($done,)* $crate::rc!(@dimension [$($current)+]),] [] $($rest)+)
            };
            (@dimensions [$($done:expr,)*] [$($current:tt)+] ,) => {
                [$($done,)* $crate::rc!(@dimension [$($current)+])]
            };
            (@dimensions [$($done:expr,)*] [$($current:tt)*] $next:tt $($rest:tt)*) => {
                $crate::rc!(@dimensions [$($done,)*] [$($current)* $next] $($rest)*)
            };
            (@dimensions [$($done:expr,)*] [$($current:tt)+]) => {
                [$($done,)* $crate::rc!(@dimension [$($current)+])]
            };
            (@dimensions [$($done:expr,)*] []) => {
                [$($done,)*]
            };
            (* $($dims:tt)*) => {{
                $crate::rc!(@read []; * $($dims)*)
            }};
            ($ty:ty; [$($bracketed:tt)*] $(, $($more:tt)*)?) => {
                compile_error!("rc! dimensions are comma-separated; do not wrap them in square brackets")
            };
            ($ty:ty; $($dims:tt)*) => {{
                $crate::rc!(@read [$ty]; $($dims)*)
            }};
            ([$($bracketed:tt)*] $(, $($more:tt)*)?) => {
                compile_error!("rc! dimensions are comma-separated; do not wrap them in square brackets")
            };
            ($($dims:tt)*) => {{
                $crate::rc!(@read []; $($dims)*)
            }};
        }

        #[macro_export]
        macro_rules! w {
            () => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                io.nl();
            }};
            (@write $io:ident; # $last:expr;) => {{ $io.write_text(&$last); }};
            (@write $io:ident; # $last:expr,) => {{ $io.write_text(&$last); $io.sp(); }};
            (@write $io:ident; # $last:expr) => {{ $io.write_text(&$last); $io.nl(); }};
            (@write $io:ident; # $first:expr, $($rest:tt)+) => {{ $io.write_text(&$first); $io.sp(); $crate::w!(@write $io; $($rest)+); }};
            (@write $io:ident; # $first:expr; $($rest:tt)+) => {{ $io.write_text(&$first); $crate::w!(@write $io; $($rest)+); }};
            (@write $io:ident; $last:expr;) => {{ $io.write_flat(&$last); }};
            (@write $io:ident; $last:expr,) => {{ $io.write_flat(&$last); $io.sp(); }};
            (@write $io:ident; $last:expr) => {{ $io.write_flat(&$last); $io.nl(); }};
            (@write $io:ident; $first:expr, $($rest:tt)+) => {{ $io.write_flat(&$first); $io.sp(); $crate::w!(@write $io; $($rest)+); }};
            (@write $io:ident; $first:expr; $($rest:tt)+) => {{ $io.write_flat(&$first); $crate::w!(@write $io; $($rest)+); }};
            ($($tokens:tt)+) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                $crate::w!(@write io; $($tokens)+);
            }};
        }

        #[macro_export]
        macro_rules! wf {
            ($($arg:tt)*) => {{
                let io = unsafe { $crate::lib::io::IO.as_mut().unwrap_unchecked() };
                io.wfmt(format_args!($($arg)*));
                io.nl();
            }};
        }

        #[macro_export]
        macro_rules! flush {
            () => {{
                $crate::lib::io::flush_output();
            }};
        }

        #[macro_export]
        macro_rules! main {
            (single = $single_test_case:expr $(,)?) => {
                fn main() {
                    let _io = $crate::lib::io::Io::new();
                    if $single_test_case {
                        $crate::solve();
                    } else {
                        let test_cases: usize = $crate::r!();
                        for _ in 0..test_cases {
                            $crate::solve();
                        }
                    }
                }
            };
        }

        #[macro_export]
        macro_rules! d {
            () => {{
                if cfg!(debug_assertions) {
                    $crate::lib::io::flush_output();
                    eprintln!("[{}:{}:{}]", file!(), line!(), column!());
                }
            }};
            (# $value:expr $(,)?) => {{
                match $value {
                    value => {
                        if cfg!(debug_assertions) {
                            let text = $crate::lib::io::debug_text(&value);
                            $crate::lib::io::flush_output();
                            eprintln!(
                                "[{}:{}:{}] {} = {}",
                                file!(), line!(), column!(), stringify!($value), text,
                            );
                        }
                        value
                    }
                }
            }};
            ($value:expr $(,)?) => {{
                match $value {
                    value => {
                        if cfg!(debug_assertions) {
                            $crate::lib::io::flush_output();
                            eprintln!(
                                "[{}:{}:{}] {} = {:?}",
                                file!(), line!(), column!(), stringify!($value),
                                &&value as &dyn ::std::fmt::Debug,
                            );
                        }
                        value
                    }
                }
            }};
            ($($value:expr),+ $(,)?) => {{
                (
                    $(
                        match $value {
                            value => {
                                if cfg!(debug_assertions) {
                                    $crate::lib::io::flush_output();
                                    eprintln!(
                                        "[{}:{}:{}] {} = {:?}",
                                        file!(), line!(), column!(), stringify!($value),
                                        &&value as &dyn ::std::fmt::Debug,
                                    );
                                }
                                value
                            }
                        }
                    ),+,
                )
            }};
        }
    }
    // }}}

    // {{{ imports
    pub use self::imports::*;

    mod imports {
        #![allow(unused_imports)]

        pub use itertools::*;
        pub use itertools::{Intersperse, IntersperseWith, chain}; // remove once undeprecated from std::iter
        pub use itertools::{max as imax, min as imin};
        pub use std::cmp::{max, min};
        pub use std::iter::{Product, RepeatN, Zip, repeat_n, zip};

        pub use std::cmp::Ordering::*;
        pub use std::cmp::*;
        pub use std::collections::*;
        pub use std::convert::*;
        pub use std::hash::*;
        pub use std::iter::*;
        pub use std::mem::*;
        pub use std::num::*;
        pub use std::ops::*;
    }
    // }}}

    // {{{ helpers
    #[allow(unused_imports)]
    pub use helpers::*;

    mod helpers {
        #[macro_export]
        macro_rules! min {
            ($($x:expr),+ $(,)?) => {
                itertools::Itertools::minmax([ $($x),+ ].into_iter()).into_option().unwrap().0
            };
        }

        #[macro_export]
        macro_rules! max {
            ($($x:expr),+ $(,)?) => {
                itertools::Itertools::minmax([ $($x),+ ].into_iter()).into_option().unwrap().1
            };
        }
    }
    // }}}
}

// }}}

main!(single = false);

fn solve() {
    //
}
