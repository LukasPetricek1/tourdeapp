import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Think Different Academy",
  description: "Hra piškvorky.",
  icons : { 
    icon : "/SVG/frontend/public/Logos/SVG/Think-different-Academy_LOGO_erb.svg.svg"
  }
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="cs">
      <body>
        {children}
      </body>
    </html>
  );
}
