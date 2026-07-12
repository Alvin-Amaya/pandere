// import { getMenu } from "./actions";

export default async function myLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {

  // const menu = await getMenu();

  return (
    <div className="flex">
        <nav>Its</nav>
        <main>{children}</main>
    </div>
  );
}
