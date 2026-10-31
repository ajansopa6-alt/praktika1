# LIPJANI BUSINESS

PHP and MySQL directory for real businesses in Lipjan, Kosovo. Public pages only query approved listings. Owners supply business addresses and map coordinates; administrators approve them before they appear publicly.

## Requirements

- PHP 8.1+ with PDO MySQL, Fileinfo and sessions
- MySQL 8.0+ or MariaDB 10.5+
- A web server configured to serve this folder and execute PHP
- Internet connection for Google Fonts, Leaflet and OpenStreetMap tiles

## Installation

1. Create a MySQL database and import `database/schema.sql` (the script creates `lipjani_business` and its tables/categories).
2. Copy `config.example.php` to `config.php` and set the database host, database name, username and password. `config.php` is ignored by Git.
3. From this folder, run `php install.php` once. It creates or resets the specified administrator account with a PHP password hash.
4. Ensure `uploads/` is writable by the PHP process. Keep PHP execution disabled inside that folder in production.
5. Point Apache/Nginx document root to this folder (or use `php -S 127.0.0.1:8000` for local development), then open the site.

### Start with Python and XAMPP on Windows

If XAMPP is installed at `C:\xampp`, double-click `start.py` or run `python start.py` from this project folder. The launcher starts XAMPP MySQL if needed, imports the schema safely, initializes the admin if missing, starts XAMPP PHP's built-in server, and opens the local site. Keep the Python window open while using the site; press Ctrl+C there to stop its PHP server. It expects MySQL on port 3306 and the default XAMPP database login in `config.php` (root with an empty password). If you changed those credentials, edit `config.php` first. Set the `XAMPP_HOME` environment variable if XAMPP is installed outside `C:\xampp`.

Administrator login after initialization:

- Email: `lipjani@gmail.com`
- Password: `123`

The requested password is weak. Change it immediately before exposing the installation to the internet. It is stored as a password hash and never put in public HTML or JavaScript. The initializer requires `--force` to reset an existing administrator password.

## Implemented flows

- Customer and owner registration, email or phone sign-in, session-based roles and CSRF-protected forms.
- Search and category filtering over approved businesses.
- Owner listing create/edit, exact map marker selection, hours, description, phone and image uploads; edits return to pending review.
- Administrator approval, rejection and deletion, customer review moderation, counts and activity records.
- Approved business profiles, call-to-dial links with click counts, OpenStreetMap maps, Google Maps directions, moderated reviews and customer favorites.
- Responsive directory, listing cards, owner/admin workspaces, image validation and installation SQL.

## Location and accuracy

The starter database contains three public restaurant listings with sourced phone numbers, street names and OpenStreetMap coordinates. The location map opens at Lipjan town centre as a viewing frame; this is not a business marker. Other listings require owner-submitted coordinates and administrator review. Ratings and activity totals are real database values, not seeded demo numbers. The administrator can reject or remove a starter listing if a business asks for a correction.

Starter listing sources: [Proper Pizza contact details](https://www.gjithebiznesi.com/XK/proper-pizza-lipjan-045-208-283) and [OpenStreetMap location](https://mapcarta.com/N5950838827); [Pa Lek Pizza contact details](https://semeny.no/xk/sted/palekpizza) and [OpenStreetMap location](https://mapcarta.com/N13720093605); [Rozafa-1 contact details](https://www.gjithebiznesi.com/XK/rozafa-lipjan-044-103-888) and [OpenStreetMap location](https://mapcarta.com/N4682345994). Opening hours are left unlisted where a reliable weekly schedule was unavailable.

## External services and production hardening

Google OAuth is not enabled because no Google OAuth client credentials were supplied; the interface does not pretend that Google sign-in works. Use HTTPS, strong unique admin credentials, database backups, server-side upload limits, and a production error logger. Configure rate limiting, password reset and email verification before a public launch. OpenStreetMap usage must follow its current tile usage policy; production traffic may require a managed tile provider.
