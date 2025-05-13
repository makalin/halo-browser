#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

use tauri::Manager;
use std::sync::Mutex;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
struct BrowserState {
    history: Vec<String>,
    bookmarks: Vec<String>,
}

struct State {
    browser: Mutex<BrowserState>,
}

#[tauri::command]
async fn add_bookmark(state: tauri::State<'_, State>, url: String) -> Result<(), String> {
    let mut browser = state.browser.lock().map_err(|_| "Failed to lock state")?;
    browser.bookmarks.push(url);
    Ok(())
}

#[tauri::command]
async fn get_bookmarks(state: tauri::State<'_, State>) -> Result<Vec<String>, String> {
    let browser = state.browser.lock().map_err(|_| "Failed to lock state")?;
    Ok(browser.bookmarks.clone())
}

fn main() {
    let state = State {
        browser: Mutex::new(BrowserState {
            history: Vec::new(),
            bookmarks: Vec::new(),
        }),
    };

    tauri::Builder::default()
        .manage(state)
        .invoke_handler(tauri::generate_handler![add_bookmark, get_bookmarks])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
} 