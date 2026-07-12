import { getProjects } from "./actions";

export default async function Dashboard(){
    const projects = await getProjects();

    return (
        <div className="flex flex-col flex-1 items-center justify-center bg-zinc-50 font-sans">
            <div className="flex flex-1 w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white sm:items-start">
                <h1>Dashboard</h1>
                <h2>Projects</h2>
                {projects.map((project) => (
                    <div key={project.id}>
                        <h3>{project.name}</h3>
                        <p>{project.description}</p>
                    </div>
                ))}
            </div>
        </div>
    )
}