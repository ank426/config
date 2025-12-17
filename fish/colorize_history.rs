use std::process::{Command, Stdio};
use std::io::{self, BufReader, Read, Write};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    const TIME_LEN: usize = 19;
    const PREFIX: &str = "               │ ";
    const BATCH_SIZE: usize = 100;

    let mut todo = true;
    while todo {
        todo = false;
        let mut num_lines = [0u8; BATCH_SIZE];
        let mut times = [[0u8; TIME_LEN]; BATCH_SIZE];

        let mut child = Command::new("fish_indent")
            .arg("--ansi")
            .stdin(Stdio::piped())
            .stdout(Stdio::piped())
            .spawn()?;
        let mut stdin = child.stdin.take().unwrap();
        let stdout = child.stdout.take().unwrap();

        let mut idx = 0;
        let mut c = 0;
        for byte in BufReader::new(io::stdin()).bytes().flatten() {
            if c < TIME_LEN {
                times[idx][c] = byte;
                c += 1;
            } else {
                stdin.write_all(&[if byte == b'\0' { b'\n' } else { byte }])?;
            }
            if byte == b'\n' {
                num_lines[idx] += 1;
            }
            if byte == b'\0' {
                num_lines[idx] += 1;
                idx += 1;
                c = 0;
                if idx >= BATCH_SIZE {
                    todo = true;
                    break;
                }
            }
        }

        drop(stdin);

        let mut color: Vec<u8> = "\x1b[90m".bytes().collect();
        let mut in_esc = false;
        let mut l = 0;
        idx = 0;
        print!("\x1b[90m");
        io::stdout().write_all(&times[0])?;
        for byte in BufReader::new(stdout).bytes().flatten() {
            if byte == b'\n' {
                l += 1;
                if l == num_lines[idx] {
                    print!("\0");
                    idx += 1;
                    l = 0;
                    if idx >= BATCH_SIZE - 1 {
                        break;
                    }
                    print!("\x1b[90m");
                    io::stdout().write_all(&times[idx])?;
                } else if byte == b'\n' {
                    print!("\n\x1b[90m{PREFIX}{}", String::from_utf8_lossy(&color));
                }
            } else {
                io::stdout().write_all(&[byte])?;
                if byte == b'\x1b' {
                    in_esc = true;
                    color.clear();
                }
                if in_esc {
                    color.push(byte);
                    if byte == b'm' {
                        in_esc = false;
                    }
                }
            }
        }
    }
    Ok(())
}
