import Image from "next/image";

export default function Page() {
  return (
    <div className="flex flex-col flex-1 items-center justify-center bg-zinc-50 font-sans">
      <main className="flex flex-1 w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white sm:items-start">
        <h1>Hola</h1>
        <a href="/home">Ir a la página de inicio</a>
      </main>
    </div>
  );
}
